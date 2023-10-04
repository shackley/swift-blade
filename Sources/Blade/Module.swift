/// Declares a group of providers that can be used to satisfy dependencies.
///
/// Initializer-based `@Provider`s are included in a module by specifying the provided type via the `@Module` attribute's `provides` parameter.
///
/// Static `@Provider`s are embedded directly within a module.
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
