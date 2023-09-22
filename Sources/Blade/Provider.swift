/// Declares a function that can be used to satisfy a dependency of a specific type.
///
/// A `@Provider` function's return type dictates the type of the dependency that it satisfies.
/// Provider functions can have dependencies of their own in the form of function parameters.
/// When an object dependency graph requires an instance of a specific type, a provider function
/// that matches that type will be invoked to obtain one.
///
/// ## Example
///
/// ```swift
/// @Module
/// public enum FooModule {
///     @Provider
///     static func provideFoo(bar: Bar) -> Foo {
///         Foo(bar: bar)
///     }
/// }
/// ```
///
/// - Parameters:
///   - scope: TODO
///   - named: Used to distinguish between multiple provider functions that return the same type.
///
/// - Precondition: Provider functions must be static and must be defined within a module.
@attached(peer, names: named(_$BladeDependencyProvider))
public macro Provider(
    of: Any.Type? = nil,
    scope: Scope = .unscoped,
    named: String? = nil
) = #externalMacro(module: "BladePlugin", type: "ProviderMacro")
