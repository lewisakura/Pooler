# Pooler

Fast and easy to use instance pooler

<!--moonwave-hide-before-this-line-->

## Why use an instance pooler?

Take the scenario of a bullet hell game. Think [Touhou](https://en.wikipedia.org/wiki/Touhou_Project). These games generally have a lot of objects:

![bullets!!!](https://pbs.twimg.com/media/Dd57rC3UwAIHktD.jpg)

It's more performant to recycle these objects than destroy and recreate them. Whilst the differences are small, when the time it takes adds up,
your game will be a lot slower by removing and creating instances when compared to using an instance pooler.

## Why use Pooler?

Pooler is designed to take any instance type and pool it. The majority of poolers I've seen can only accept parts and the ones I've seen that don't
do not have much customizability. I wrote Pooler to fill that gap for myself, and now I'm releasing it here.

Needless to say, Pooler is not perfect. There are many improvements that can be made, especially related to returning objects to the pool and what to
do on exhaustion. For the majority of tasks, however, Pooler is a suitable library that will handle thousands of objects easily.

## Getting Started

Create your Pooler:

```lua
local template = Instance.new("Part")

template.Anchored = true

template.Material = Enum.Material.Neon
template.BrickColor = BrickColor.Green()

local pool = Pooler.new(template)
```

Now, you can fetch instances from it:

```lua
local instance = pool:Get()
```

Once you're done with that instance, just (optionally) return it to the pool again:

```lua
pool:Return(instance)
```
