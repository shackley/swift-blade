# Components

Generating and accessing the dependency graph.

## Overview

An application's provider functions form a graph of types, linked by their dependencies.

@Image(source: "graph.png", alt: "An illustration of a dependency graph.")

Calling code like an application’s `@main` function accesses that graph via a set of roots. That set is defined via a protocol with functions that have no arguments and return the root types.

Applying the `@Component` attribute to such a protocol and declaring the modules that can used to obtain instances of dependencies, swift-blade then generates an implementation of that protocol.

```swift
@Component(modules = [CoffeeModule.self])
protocol CoffeeShop {
    func maker() -> CoffeeMaker
}
```

The generated implementation has the same name as the interface prefixed with "Blade".

```swift
@main
struct CoffeeApp {
    static func main() {
        let coffeeShop = BladeCoffeeShop()
        coffeeShop.maker().brew()
    }
}
```

## Topics

- ``Component(modules:)``
