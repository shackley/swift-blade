#  Named Dependencies

Distinguishing between unqiue dependencies of the same type.

## Overview

Sometimes the type alone is insufficient to identify a dependency.

In these cases, dependencies of the same type can be distinguished by adding the `@Named` attribute to the parameter of a `@Provider`.

```swift
class DualBoilerCoffeeMaker {
    private let waterHeater: Heater
    private let milkHeater: Heater

    @Provider
    init(
        @Named("water") waterHeater: Heater,
        @Named("milk") milkHeater: Heater
    ) {
        self.waterHeater = waterHeater
        self.milkHeater = milkHeater
    }

    ...
}
```

Named dependencies are provided by their matching `named` `@Provider`.

> Only static function `@Provider`s can be named.

```swift
@Module(provides: [CoffeeMaker.self])
public enum CoffeeModule {
    @Provider(named: "water")
    static func provideWaterHeater() -> Heater {
        ElectricHeater(temperature: 212.0)
    }

    @Provider(named: "milk")
    static func provideMilkHeater() -> Heater {
        ElectricHeater(temperature: 140.0)
    }
}
```

## Topics

- ``Named``
