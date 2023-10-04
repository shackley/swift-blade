# Modules

Registering dependency providers.

## Overview

All providers must be registered to a module. Modules are just empty enums that have the `@Module` attribute.

Initializer-based `@Provider`s are included in a module by specifying the provided type via the `@Module` attribute's `provides` parameter.

Static `@Provider`s are embedded directly within a module.

```swift
@Module(provides: [CoffeeMaker.self, Thermosiphon.self])
public enum CoffeeModule {
    @Provider
    static func provideHeater() -> Heater {
        ElectricHeater()
    }

    @Provider
    static func providePump(pump: Thermosiphon) -> Pump {
        pump
    }
}
```

## Topics

- ``Module(provides:submodules:)``
