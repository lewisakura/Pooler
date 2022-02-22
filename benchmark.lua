-- this script acts as a benchmark and a more intensive test of Pooler, and is also where the 42% increase in performance was gathered.
-- the 42% comes from the first benchmark, comparing the baseline to unsafe CFrame mode.

local Pooler = require(script.Parent.Pooler)

local template = Instance.new("Part")

local function benchmark(name, action, count)
	local times = {}

	while true do
		local start = os.clock()

		action()

		table.insert(times, os.clock() - start)

		if #times == count then
			break
		end

		task.wait()
	end

	local avg = 0
	for _, v in pairs(times) do
		avg += v
	end

	avg = avg / #times

	print(name, ": ", avg)
end

local benchmarkCount = 1000

print("Running benchmarks x" .. benchmarkCount)
print()
print("Equivalent to:")
print("local instance = Instance.new('Part')")
print("instance.CFrame = workspace.Emitter.CFrame")
print("instance.Parent = workspace.Parts")
print("game.Debris:AddItem(instance, 3)")
print()
print("All Poolers use 250 parts.")
print("-------------------------------------------------------------------------------")

do
	benchmark("Baseline", function()
		local instance = Instance.new("Part")

		instance.CFrame = workspace.Emitter.CFrame
		instance.Parent = workspace.Parts

		game.Debris:AddItem(instance, 3)
	end, benchmarkCount)

	for _, v in pairs(workspace.Parts:GetChildren()) do
		game.Debris:AddItem(v, 0)
	end

	local poolNil = Pooler.new(template, { count = 250 })

	benchmark("Pooler (in nilParent mode)", function()
		local instance = poolNil:Get()

		instance.CFrame = workspace.Emitter.CFrame
		instance.Parent = workspace.Parts

		task.delay(3, function()
			poolNil:Return(instance)
		end)
	end, benchmarkCount)

	task.wait(3)

	poolNil:Destroy()

	local poolCframe = Pooler.new(template, { count = 250, returnMethod = "cframe" })

	benchmark("Pooler (in cframe mode)", function()
		local instance = poolCframe:Get()

		instance.CFrame = workspace.Emitter.CFrame
		instance.Parent = workspace.Parts

		task.delay(3, function()
			poolCframe:Return(instance)
		end)
	end, benchmarkCount)

	task.wait(3)

	poolCframe:Destroy()

	local poolNilUnsafe = Pooler.new(template, { count = 250, unsafe = true })

	benchmark("Pooler (in nilParent mode) (unsafe)", function()
		local instance = poolNilUnsafe:Get()

		instance.CFrame = workspace.Emitter.CFrame
		instance.Parent = workspace.Parts

		task.delay(3, function()
			poolNilUnsafe:Return(instance)
		end)
	end, benchmarkCount)

	task.wait(3)

	poolNilUnsafe:Destroy()

	local poolCframeUnsafe = Pooler.new(template, { count = 250, returnMethod = "cframe", unsafe = true })

	benchmark("Pooler (in cframe mode) (unsafe)", function()
		local instance = poolCframeUnsafe:Get()

		instance.CFrame = workspace.Emitter.CFrame
		instance.Parent = workspace.Parts

		task.delay(3, function()
			poolCframeUnsafe:Return(instance)
		end)
	end, benchmarkCount)

	task.wait(3)

	poolCframeUnsafe:Destroy()
end

print("-------------------------------------------------------------------------------")

print()
print("Equivalent to:")
print("Instance.new('Part'):Destroy()")
print()
print("All Poolers use 250 parts.")
print("-------------------------------------------------------------------------------")

do
	benchmark("Baseline", function()
		Instance.new("Part"):Destroy()
	end, benchmarkCount)

	local poolNil = Pooler.new(template, { count = 250 })

	benchmark("Pooler (in nilParent mode)", function()
		poolNil:Return(poolNil:Get())
	end, benchmarkCount)

	poolNil:Destroy()

	local poolNilUnsafe = Pooler.new(template, { count = 250, unsafe = true })

	benchmark("Pooler (in nilParent mode) (unsafe)", function()
		poolNilUnsafe:Return(poolNilUnsafe:Get())
	end, benchmarkCount)

	poolNilUnsafe:Destroy()
end

print("-------------------------------------------------------------------------------")
print()
print("Benchmarks complete")
