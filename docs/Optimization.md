---
sidebar_position: 4
---

# Optimization

You want your instance pooling to be fast. That was the point of implementing it after all, right? So, let's make it fast(er)!

## Scaling up the pool

The default size of the pool is 100. Depending on your use case, this will be way too little instances. Pass `size = <n>` to increase the
default pool size.

### Dynamic scaling

Pooler supports a form of dynamic scaling by using `pool:Resize(newSize)`. This will automatically add or remove instances depending on
on the new size. You can also get the current size by using `pool:Size()` to introduce some automatic scaling based on pool usage.

## Using a different return method

If you're using `BasePart`s or `Model`s with PrimaryPart set, then you should be using the `cframe` return method instead of the default
`nilParent` return method. This will cause the parts or models to be CFramed away outside of the map rather than modifying the parent,
which is a much more costly operation.

## Disabling safety

The largest amount of time is dedicated to safety. If you _know_ that your calls to Pooler are correct, you don't need to bother.
When creating your pool, pass `unsafe = true` as an option to disable safety. This will speed up your pool drastically at the cost
of being able to create some weird bugs if you don't check your code properly.
