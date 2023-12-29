#if canImport(os)
import os
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported platform")
#endif

final class UnfairLock<State> {
    private var state: State
#if canImport(os)
    private let lock = UnsafeMutablePointer<os_unfair_lock_s>.allocate(capacity: 1)
#elseif canImport(Glibc)
    private let mutex = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
#endif

    public init(initialState: State) {
        self.state = initialState
#if canImport(os)
        lock.initialize(to: os_unfair_lock_s())
#elseif canImport(Glibc)
        pthread_mutex_init(mutex, nil)
#endif
    }

    deinit {
#if canImport(os)
        lock.deallocate()
#elseif canImport(Glibc)
        pthread_mutex_destroy(mutex)
        mutex.deallocate()
#endif
    }

    func withLock<R>(_ body: (inout State) throws -> R) rethrows -> R {
#if canImport(os)
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
#elseif canImport(Glibc)
        pthread_mutex_lock(mutex)
        defer { pthread_mutex_unlock(mutex) }
#endif
        return try body(&state)
    }
}
