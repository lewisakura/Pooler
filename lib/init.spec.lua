--!nocheck
--^ see line 16

return function()
	local CollectionService = game:GetService("CollectionService")

	local Pooler = require(script.Parent)

	describe("creation", function()
		it("should create a new instance", function()
			expect(Pooler.new(Instance.new("Part"))).to.be.a("table")
		end)

		it("should fail without a template", function()
			expect(function()
				Pooler.new()
			end).to.throw()
		end)

		it("should fail with an invalid configuration", function()
			expect(function()
				Pooler.new(Instance.new("Sound"), { returnMethod = "cframe" })
			end).to.throw("cannot create Pooler with cframe return method if instance template is not a BasePart or Model")
		end)

		it("should create a random instance with random getMethod", function()
			local instance = Pooler.new(Instance.new("Part"), { getMethod = "random" })
			expect(instance._random).to.be.a("userdata")
		end)
	end)

	describe("pooling", function()
		local template = Instance.new("Part")
		local pool = Pooler.new(template, { size = 50 })

		it("should have a certain amount of instances in the pool already", function()
			expect(pool:Size()).to.equal(50)
		end)

		it("should tag all instances with a certain pool tag", function()
			for _, v in pairs(pool._pool) do
				expect(function()
					if not CollectionService:HasTag(v, "pooler_" .. pool._id) then
						error("No tag!")
					end
				end).never.to.throw()
			end
		end)

		it("should get an instance", function()
			expect(pool:Get()).to.be.ok()
		end)

		it("should be able to return an instance", function()
			expect(function()
				local instance = pool:Get()
				pool:Return(instance)

				if CollectionService:HasTag(instance, "pooler_inUse") then
					error("Still in use!")
				end
			end).never.to.throw()
		end)

		it("should be able to resize the pool", function()
			pool:Resize(100)
			expect(pool:Size()).to.equal(100)

			pool:Resize(50)
			expect(pool:Size()).to.equal(50)
		end)

		it("should not be usable after being destroyed", function()
			pool:Destroy()

			expect(function()
				pool:Get()
			end).to.throw("attempt to use destroyed Pooler instance")
		end)
	end)

	describe("exhaustion", function()
		local template = Instance.new("Part")
		local exhaustionPool = Pooler.new(template, { size = 50, exhaustion = true })

		it("should start with 50 instances", function()
			expect(exhaustionPool:Size()).to.equal(50)
		end)

		it("should remove and add instance after getting and returning", function()
			local instance = exhaustionPool:Get()
			expect(exhaustionPool:Size()).to.equal(49)

			exhaustionPool:Return(instance)
			expect(exhaustionPool:Size()).to.equal(50)
		end)

		it("should destroy and remove all instances from the pool", function()
			exhaustionPool:Destroy()
			expect(exhaustionPool:Size()).to.equal(0)
		end)
	end)
end
