/// Declares a function that can be used to satisfy a dependency of a specific type.
///
/// A `@Provider` function's return type dictates the type of the dependency that it satisfies.
///
/// Provider functions can have dependencies of their own in the form of function parameters.
///
/// When an instance of a specific type is required, the provider function that matches that type will be invoked to obtain one.
///
/// - Parameters:
///   - of: Specifies the type that is being provided. This parameter is only necessary for initializer-based providers.
///   - scope: Defines the lifecycle of a provided instance.
///   - named: Used to distinguish between multiple provider functions that return the same type.
@attached(peer, names: named(_$BladeDependencyProvider))
public macro Provider(
    of: Any.Type? = nil,
    scope: Scope = .unscoped,
    named: String? = nil
) = #externalMacro(module: "BladePlugin", type: "ProviderMacro")
