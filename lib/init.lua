--!nocheck
--^ Luau will warn in the `new` function, and I'd rather not have people complain about warnings when they add the module.

local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

--[=[
	@class Pooler
	An instance pooler.
]=]
local Pooler = {}
Pooler.__index = Pooler

type Pooler<T> = {
	Get: (self: Pooler<T>) -> T,
	Wait: (self: Pooler<T>) -> T,

	Return: (self: Pooler<T>, instance: T) -> (),

	Resize: (self: Pooler<T>, newSize: number) -> (),
	Size: (self: Pooler<T>) -> number,

	Destroy: (self: Pooler<T>) -> (),
}

--[=[
	@type GetMethod "sequential" | "random"
	@within Pooler
	The method that this Pooler should use to retrieve instances. `sequential` will retrieve them in an ascending order (item 1 -> item `n`)
	whilst `random` will retrieve instances randomly.
]=]
-- NOTE: Due to LSP bug and Moonwave extractor not working, this type has to be made more generic. The more specific type is commented.
type GetMethod = string --"sequential" | "random"

--[=[
	@type ReturnMethod "nilParent" | "cframe"
	@within Pooler
	The method that this Pooler should use to return instances. `nilParent` will set the instance's parent to `nil` and leave all other
	properties intact whilst `cframe` will set the CFrame of the instance to a very long distance away, which is faster for BaseParts
	and Models with PrimaryPart set. `cframe`, as such, is only supported if you're pooling BaseParts or Models.
]=]
-- NOTE: Due to LSP bug and Moonwave extractor not working, this type has to be made more generic. The more specific type is commented.
type ReturnMethod = string --"nilParent" | "cframe"

--[=[
	@interface Options
	@within Pooler
	.size number? -- The number of objects to initialise this pool with. Defaults to 100.
	.getMethod GetMethod? -- The get method to use. Defaults to "sequential".
	.returnMethod ReturnMethod? -- The return method to use. Defaults to "nilParent".
	.unsafe boolean? -- Whether or not the Pooler should skip safety checks. This pretty much means that you're on your own when it comes to doing things properly, but it increases performance. Defaults to false.
	.exhaustion boolean? -- Whether or not the pool can be exhausted. When enabled, instances will be removed from the internal pool table and you will have to return them yourself to add them back. Defaults to false.

	An object that describes any extra options you want to pass when creating a Pooler. All options are not required.
]=]
type Options = {
	size: number?,
	getMethod: GetMethod?,
	returnMethod: ReturnMethod?,
	unsafe: boolean?,
	exhaustion: boolean?,
}

--[=[
	Creates a new Pooler instance.

	```lua
	local pool = Pooler.new(Instance.new("Part"))
	```

	@tag Constructor

	@param instanceTemplate T -- The instance that this Pooler should base its pooled objects on.
	@param opts Options? -- Any extra options you want to pass.

	@return Pooler<T> -- A Pooler instance.

	@error "cannot create Pooler without an instance template" -- Occurs when you're attempting to create a Pooler without a template.
	@error "cannot create Pooler with cframe return method if instance template is not a BasePart or Model" -- Occurs when trying to use the `cframe` ReturnMethod when your template isn't a BasePart or a Model.
	@error "cannot create Pooler with cframe return method if instance template is a Model and it has no PrimaryPart" -- Occurs when trying to use the `cframe` ReturnMethod when your template is a Model and it has no PrimaryPart.
	@error "cannot use random getMethod with exhaustion enabled" -- Occurs when you're trying to use the `random` GetMethod with `exhaustion` enabled. `random` is not a valid GetMethod since it might retrieve a nil value.
]=]
function Pooler.new<T>(instanceTemplate: T, opts: Options?): Pooler<T>
	if not instanceTemplate then
		error("cannot create Pooler without an instance template")
	end

	local pool = {}

	local options = opts
		or {
			size = 100,
			getMethod = "sequential",
			returnMethod = "nilParent",
			unsafe = false,
			exhaustion = false,
		}

	if options.size == nil then
		options.size = 100
	end
	if options.getMethod == nil then
		options.getMethod = "sequential"
	end
	if options.returnMethod == nil then
		options.returnMethod = "nilParent"
	end
	if options.unsafe == nil then
		options.unsafe = false
	end
	if options.exhaustion == nil then
		options.exhaustion = false
	end

	if options.exhaustion and options.getMethod == "random" then
		error("cannot use random get method with exhaustion enabled")
	end

	if options.returnMethod == "cframe" then
		if not (instanceTemplate:IsA("BasePart") or instanceTemplate:IsA("Model")) then
			error("cannot create Pooler with cframe return method if instance template is not a BasePart or Model")
		end

		if instanceTemplate:IsA("Model") and instanceTemplate.PrimaryPart == nil then
			error(
				"cannot create Pooler with cframe return method if instance template is a Model and it has no PrimaryPart"
			)
		end
	end

	local id = HttpService:GenerateGUID(false)

	for _ = 1, options.size do
		local inst = instanceTemplate:Clone()
		if not options.unsafe then
			CollectionService:AddTag(inst, "pooler_" .. id)
		end
		table.insert(pool, inst)
	end

	return (
			setmetatable({
				_id = id,
				_random = if options.getMethod == "random" then Random.new() else nil,
				_nextItem = if options.getMethod == "sequential" then 1 else nil,

				_restockEvent = if options.exhaustion then Instance.new("BindableEvent") else nil,

				_template = instanceTemplate:Clone(),
				_pool = pool,
				_options = options,

				_destroyed = false,
				_exhaustionWarning = false,
			}, Pooler) :: any
		) :: Pooler<T>
end

--[=[
	Gets an instance from the pool.

	```lua
	local pool = Pooler.new(Instance.new("Part"))

	local instance = pool:Get()
	```

	@return T -- An instance.

	@error "attempt to use destroyed Pooler instance" -- Occurs when this Pooler has been destroyed and you are trying to call methods on it.
	@error "pool exhausted" -- Occurs when the pool has been exhausted of all of it's instances and exhaustion is enabled.
]=]
function Pooler:Get(): Instance
	if self._destroyed then
		error("attempt to use destroyed Pooler instance")
	end

	if self._options.exhaustion and #self._pool == 0 then
		error("pool exhausted")
	end

	local instance

	if self._options.getMethod == "sequential" then
		if self._options.exhaustion then
			instance = table.remove(self._pool, 1) -- with exhaustion enabled, we can just shift the items down, although this is more expensive
		else
			if self._nextItem > #self._pool then
				self._nextItem = 1
			end

			instance = self._pool[self._nextItem]

			self._nextItem += 1
		end
	elseif self._options.getMethod == "random" then
		instance = self._pool[self._random:NextInteger(1, #self._pool)]
	end

	if not self._options.exhaustion then
		self:Return(instance)
	end

	if not self._options.unsafe then
		CollectionService:AddTag(instance, "pooler_inUse")
	end

	return instance
end

--[=[
	Gets an instance from the pool. If the pool is exhausted, it will wait until an instance is available before returning.

	```lua
	local pool = Pooler.new(Instance.new("Part"))

	local instance = pool:Wait()
	```

	@yields

	@return T -- An instance.

	@error "attempt to use destroyed Pooler instance" -- Occurs when this Pooler has been destroyed and you are trying to call methods on it.
]=]
function Pooler:Wait(): Instance
	if self._destroyed then
		error("attempt to use destroyed Pooler instance")
	end

	if not self._options.exhaustion then
		return self:Get() -- don't bother, just go through the standard Get call
	end

	if #self._pool == 0 then
		self._restockEvent.Event:Wait()
	end

	return self:Get()
end

--[=[
	Returns an instance to the pool.

	```lua
	local pool = Pooler.new(Instance.new("Part"))

	local instance = pool:Get()

	pool:Return(instance)
	```

	@param instance T -- The instance to return.

	@error "attempt to use destroyed Pooler instance" -- Occurs when this Pooler has been destroyed and you are trying to call methods on it.
	@error "attempt to return instance not part of this pool" -- Occurs when you attempt to return an instance that wasn't a part of this pool to begin with.
	@error "instance is not a BasePart or Model but it's using the cframe return method" -- Occurs when the instance you're returning is not a BasePart or a Model, but you're somehow using the CFrame return method. If safety is enabled and you haven't been tampering with the internals, this is almost always a bug and should be reported.
]=]
function Pooler:Return(instance: Instance)
	if self._destroyed then
		error("attempt to use destroyed Pooler instance")
	end

	if not self._options.unsafe then
		if not CollectionService:HasTag(instance, "pooler_inUse") then
			return
		end

		if not CollectionService:HasTag(instance, "pooler_" .. self._id) then
			error("attempt to return instance not part of this pool")
		end
		CollectionService:RemoveTag(instance, "pooler_inUse")
	end

	if self._options.returnMethod == "cframe" then
		if instance:IsA("BasePart") then
			instance.CFrame = CFrame.new(math.huge, math.huge, math.huge)
		elseif instance:IsA("Model") then
			instance.PrimaryPart.CFrame = CFrame.new(math.huge, math.huge, math.huge)
		else
			error("instance is not a BasePart or Model but it's using the cframe return method")
		end
	elseif self._options.returnMethod == "nilParent" then
		instance.Parent = nil
	end

	if self._options.exhaustion then
		table.insert(self._pool, instance)
		self._restockEvent:Fire()
	end
end

--[=[
	Get the current size of the pool.

	```lua
	local pool = Pooler.new(Instance.new("Part"))

	local size = pool:Size()
	```

	@return number -- The size of the pool.
]=]
function Pooler:Size()
	return #self._pool
end

--[=[
	Resizes the pool.

	```lua
	local pool = Pooler.new(Instance.new("Part"))

	pool:Resize(1000)
	```

	@param newSize number -- The new size the pool should be.

	@error "attempt to use destroyed Pooler instance" -- Occurs when this Pooler has been destroyed and you are trying to call methods on it.
]=]
function Pooler:Resize(newSize: number)
	if self._destroyed then
		error("attempt to use destroyed Pooler instance")
	end

	if newSize > #self._pool then -- add more
		for _ = #self._pool, newSize - 1 do
			local instance = self._template:Clone()

			CollectionService:AddTag(instance, "pooler_" .. self._id)
			table.insert(self._pool, instance)
		end
	elseif newSize < #self._pool then -- scale back
		for i = 1, (#self._pool - newSize) do
			local instance = table.remove(self._pool, i)
			Debris:AddItem(instance, 0) -- destroy the instance to not waste memory
		end
	end
end

--[=[
	Destroys this Pooler and destroys all instances associated with the pool.

	```lua
	local pool = Pooler.new(Instance.new("Part"))

	pool:Destroy()
	```
]=]
function Pooler:Destroy()
	if self._destroyed then
		return
	end

	self._destroyed = true

	for _, v in pairs(self._pool) do
		Debris:AddItem(v, 0)
	end

	Debris:AddItem(self._template, 0)
	self._pool = {}
end

return Pooler
