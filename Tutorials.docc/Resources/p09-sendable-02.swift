// Fix: synchronize the class yourself, and tell the compiler to trust you.
nonisolated final class LockedCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var _value = 0

    func increment() {
        lock.lock()
        defer { lock.unlock() }
        _value += 1
    }
}

// `@Sendable` the *attribute* is the closure-level version of the same
// idea. You rarely write it calling `Task { }` — the standard library
// already declares that parameter as sendable — but you do need it
// when your own API hands a closure to another concurrency domain:
func performInBackground<T: Sendable>(_ work: @Sendable @escaping () async -> T) async -> T {
    await Task.detached { await work() }.value
}
