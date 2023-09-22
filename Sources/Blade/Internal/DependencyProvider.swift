/// An interface for a mechanism that can be used to obtain an instance of a specific type `T`.
///
/// `@Provider`-attributed initializers and functions generate `DependencyProvider` implementations.
/// These implementations are used to resolve dependency instances.
///
/// > Warning: This protocol is meant for swift-blade internal use.
public protocol DependencyProvider<T> {
    associatedtype T
    func get() -> T
}
