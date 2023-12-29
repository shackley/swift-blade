import Foundation

/// A wrapper class that allows for a dependency to be initialized lazily.
///
/// When the wrapped type is initialized upon invoking the ``get()`` function for the first time,
/// the initialized value will be cached and re-used across subsequent invocations of ``get()``.
///
/// It isn't necessary to declare a provider of type `Lazy<T>`. Any provider of type `T` can be used
/// to satisfy dependencies of both type `T` and `Lazy<T>`.
///
/// > Note: Lazy is thread-safe.
///
/// - Parameters:
///     - initializer: A closure that can be invoked to initialize an instance of `T`
public final class Lazy<T> {
    private enum State {
        case uninitialized(() -> T)
        case initialized(T)
    }

    private let lock: UnfairLock<State>

    public init(_ initializer: @escaping () -> T) {
        self.lock = UnfairLock(initialState: .uninitialized(initializer))
    }

    public func get() -> T {
        lock.withLock { state in
            switch state {
            case let .uninitialized(initializer):
              let value = initializer()
              state = .initialized(value)
              return value
            case let .initialized(value):
              return value
            }
        }
    }
}
