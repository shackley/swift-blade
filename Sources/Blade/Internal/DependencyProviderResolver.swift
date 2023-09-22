/// Manages a collection of `DependencyProviders` that can be used to resolve dependency graph instances.
///
/// > Warning: This class is meant for swift-blade internal use.
public final class DependencyProviderResolver {
    private var registry: [DependencyKey: () -> any DependencyProvider] = [:]
    private var providers: [DependencyKey: any DependencyProvider] = [:]

    public init() {}

    public func register<T>(
        provider: @autoclosure @escaping () -> some DependencyProvider<T>,
        name: String? = nil
    ) {
        let key = DependencyKey.from(type: T.self, name: name)
        guard registry[key] == nil else {
            if let name {
                fatalError("Duplicate provider found for type \(T.self) with name \(name)")
            } else {
                fatalError("Duplicate provider found for type \(T.self)")
            }
        }
        registry[key] = provider
    }

    public func deregister<T>(
        type: T.Type,
        name: String? = nil
    ) {
        let key = DependencyKey.from(type: T.self, name: name)
        registry[key] = nil
        providers[key] = nil
    }

    public func resolve<T>(
        type: T.Type,
        name: String? = nil
    ) -> any DependencyProvider<T> {
        let key = DependencyKey.from(type: T.self, name: name)
        if let provider = providers[key] as? any DependencyProvider<T> {
            return provider
        }
        if let provider = registry[key]?() as? any DependencyProvider<T> {
            providers[key] = provider
            return provider
        }
        if let name {
            fatalError("No provider found for type \(type) with name \(name)")
        } else {
            fatalError("No provider found for type \(type)")
        }
    }
}
