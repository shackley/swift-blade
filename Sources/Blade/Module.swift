/// Declares a group of providers that can be used to satisfy object graph dependencies.
///
/// Providers come in 2 forms:
/// - Initializer based `@Provider`s. These providers can be added to a module by declaring the provided type using the `@Module` `provides` parameter.
/// - Static `@Provider` functions. These functions are defined directly within a module.
///
/// ## Example
///
/// ```swift
/// @Module(provides: [Foo.self])
/// public enum FooModule {
///     @Provider
///     static func provideBar() -> Bar {
///         Bar()
///     }
/// }
/// ```
///
/// - Parameters:
///   - provides: Declares the types that can be provided from initializer based providers.
///   - submodules: Declares the types of modules that this module composes of.
///
/// - Precondition: Modules must be declared as empty enums.
@attached(peer, names: prefixed(_$Blade))
public macro Module(
    provides: [Any.Type] = [],
    submodules: [Any.Type] = []
) = #externalMacro(module: "BladePlugin", type: "ModuleMacro")
