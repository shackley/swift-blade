# Instance Binding

Adding existing instances to the dependency graph.

## Overview

There may be scenarios where you have some existing instances already available at the time of component initialization.

These instances can be bound directly to your application's dependency graph by defining an initializer for your component that includes parameters for the instances you wish to bind.

```swift
struct Configuration { ... }

@Component(modules = [CoffeeModule.self])
protocol CoffeeShop {
    init(configuration: Configuration)
    func maker() -> CoffeeMaker
}
```

The values passed into the initializer can then be automatically provided as dependencies to any object within the graph.

```swift
class CoffeeMaker {
    private let configuration: Configuration

    @Provider
    init(configuration: Configuration) {
        self.configuration = configuration
    }

    ...
}

func run(with configuration: Configuration) {
    let coffeeShop = BladeCoffeeShop(configuration: configuration)
    coffeeShop.maker().brew()
}
```
