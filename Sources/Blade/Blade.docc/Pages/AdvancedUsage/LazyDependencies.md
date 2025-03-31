#  Lazy Dependencies

Delaying dependency initialization until absolutely necessary.

## Overview

At times it can beneficial to delay the initialization of a dependency. This can improve the speed in which a component can be initialized in the event that it has dependencies with expensive initialization logic. 

Any dependency of type `T` can be substituted with a `Lazy<T>`. The object won't be initialized until the `Lazy<T>`'s `get()` function is called. Subsequent calls to `get()` will return the same underlying instance of `T`.

> A provider that provides some type `T` can be used to satisfy dependencies of both type `T` and `Lazy<T>`.

```swift
class GrindingCoffeeMaker {
    private let grinder: Lazy<Grinder>

    @Provider
    init(grinder: Lazy<Grinder>) {
        self.grinder = grinder
    }

    func grind() {
        grinder.get().grind()
    }
}
```

## Topics

- ``Lazy``
