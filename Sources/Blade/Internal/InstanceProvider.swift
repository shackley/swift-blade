/// A generic provider that provides a specific instance everytime it is requested.
///
/// > Warning: This class is meant for swift-blade internal use.
public final class InstanceProvider<T>: DependencyProvider {
    private let instance: T

    public init(instance: T) {
        self.instance = instance
    }

    public func get() -> T {
        instance
    }
}
