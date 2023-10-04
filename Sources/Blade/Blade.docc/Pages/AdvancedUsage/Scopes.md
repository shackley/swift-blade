#  Scopes

Defining dependency lifecycles.

## Overview

By default Blade will initialize a new instance of a dependency each time it needs to be provided. Setting an `@Provider`s `scope` to `.singleton` will limit the dependency to a single instance that is shared within a component.

> Singleton scoped dependencies are initialized immediately upon component initialization.

```swift
@Provider(scope: .singleton)
static func provideHeater() -> Heater {
    ElectricHeater()
}
```

## Topics

- ``Scope``
