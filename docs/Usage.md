---
sidebar_position: 3
---

# Usage

Pooler is a dead simple library to use. Your existing code might look like this:

```lua
local Debris = game:GetService("Debris")

local template = Instance.new("Part")

template.Anchored = false

template.Material = Enum.Material.Neon
template.BrickColor = BrickColor.Green()

while true do
    local instance = template:Clone()
    instance.Parent = workspace

    Debris:AddItem(instance, 3)

    task.wait()
end
```

This is obviously a very bizarre use case, but let's roll with it. Converting this to Pooler is quite an easy task.

1. Add Pooler to your script:

```lua
local Pooler = require(script.Parent.Pooler) -- or wherever your copy might be...
```

2. Create your instance pool:

```lua
local pool = Pooler.new(template)
```

3. Swap out your :Clone() and :AddItem() calls for the Pooler equivalents:

```lua
while true do
    local instance = pool:Get()
    instance.Parent = workspace

    task.delay(3, function()
        pool:Return(instance)
    end)

    task.wait()
end
```

:::tip Returning is optional

Here, we use `pool:Return(instance)` to make sure our instances go back to the pool after we're done. However, if the pool is exhausted,
Pooler will automatically return the instance it retrieves for you. In the standard sequential mode, it will return the oldest instances
first.

:::

Easy, right?
