# Providers

Declaring and satisfying dependencies.

## Overview

Providers tell swift-blade how to construct an instance of a specific type. They are declared using the `@Provider` attribute.

Providers come in 2 forms:
- Initializer-based providers
- Static providers

### Initializer-Based Providers

Adding the `@Provider` attribute to an initializer will allow swift-blade to provide instances of the initialized type.

The parameters of the type's initializer are its dependencies. When a new instance of that type is needed, swift-blade will obtain instances of all of its dependencies and invoke its initializer.

```swift
class Thermosiphon: Pump {
    private let heater: Heater

    @Provider
    init(heater: Heater) {
        self.heater = heater
    }

  ...
}
```

### Static Providers

Initializer-based `@Provider`s can't be used everywhere:
- Protocols can’t be initialized.
- Third-party library classes can’t be annotated.

For these cases, use a static `@Provider` function to define how a dependency should be satisfied. The function’s return type defines which dependency it satisfies.

```swift
@Provider
static func provideHeater() -> Heater {
    ElectricHeater()
}
```

Static `@Provider` functions can have dependencies of their own.

```swift
@Provider
static func providePump(pump: Thermosiphon) -> Pump {
    pump
}
``` 

This pattern is commonly used to alias a concrete type to a protocol that it conforms to.

## Topics

- ``Provider(scope:named:)``
