/// Defines the lifecycle of an instance that is provided in the object dependency graph.
///
/// Providers are ``unscoped`` by default.
public enum Scope {
    /// A singleton scoped provider will be invoked only once. The provided value will be re-used across all of its dependants.
    case singleton

    /// An unscoped provider may be invoked multiple times. The provider may initialize new instances of the provided type each time it is called.
    case unscoped
}
