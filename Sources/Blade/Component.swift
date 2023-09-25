/// Generates a dependency graph and provides access to its roots.
///
/// A component is a protocol that defines roots via functions that have no arguments and return the root types.
/// Applying the `@Component` attribute to the protocol will generate an implementation of the protocol with the prefix "Blade"
///
/// ```swift
/// @Component(modules: [CoffeeModule.self])
/// public protocol CoffeeShop {
///     func maker() -> CoffeeMaker
/// }
///
/// @main
/// struct CoffeApp {
///    static func main() {
///        let coffeeShop = BladeCoffeeShop()
///        coffeeShop.maker().brew()
///    }
/// }
/// ```
///
/// - Parameters:
///   - modules: The types of modules that can be used to resolve dependencies.
@attached(peer, names: prefixed(Blade))
public macro Component(
    modules: [Any.Type] = [],
    subcomponents: [Any.Type] = []
) = #externalMacro(module: "BladePlugin", type: "ComponentMacro")
