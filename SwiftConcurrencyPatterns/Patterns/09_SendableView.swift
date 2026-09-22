import SwiftUI
import Foundation

// MARK: - Pattern 9: Sendable
//
// `Sendable` marks a type as safe to pass across concurrency domains (into
// a `Task`, an `actor`, another thread) without risking a data race.
//
// - A `struct`/`enum` gets `Sendable` for free once every stored property
//   is itself `Sendable` (value semantics mean there's nothing to race on).
// - A `class` does NOT get this for free, because two references to the
//   same instance can be mutated from two places at once:
//
//     final class Counter {
//         var value = 0
//     }
//
//     Task.detached {
//         counter.value += 1   // ❌ error: capture of 'counter' with
//     }                        //    non-sendable type 'Counter' in a
//                               //    '@Sendable' closure
//
//   Swift 6 refuses to compile that capture — it can't prove the mutation
//   is safe. Two ways to fix it: make the type an `actor` (Pattern 6,
//   preferred), or manually synchronize access yourself and tell the
//   compiler to trust you with `@unchecked Sendable`.
//
// `@Sendable` (the attribute, as opposed to the protocol) applies to
// *closures*. You rarely write it when calling `Task { }` or
// `group.addTask { }` — the standard library already declares those
// parameters as sendable. You DO need to write it yourself when you author
// your own API that hands a closure to another concurrency domain, as
// `performInBackground` does below.

/// A plain value type: Sendable is inferred automatically because both
/// stored properties are Sendable (`String` and `Double`).
struct WeatherReport: Sendable {
    let city: String
    let temperature: Double
}

/// `@unchecked Sendable` opts out of compiler-verified safety in exchange
/// for a promise that *we* made this safe — here, with an `NSLock`. Prefer
/// `actor` whenever you can; reach for this only when wrapping something
/// the compiler can't see into, like a C library or a pre-existing
/// lock-based type.
// `nonisolated` opts the whole type out of this module's default
// main-actor isolation: the safety guarantee here comes from the lock, not
// from being confined to one actor, so callers off the main actor need to
// reach these members directly.
nonisolated final class LockedCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var _value = 0

    var value: Int {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }

    func increment() {
        lock.lock()
        defer { lock.unlock() }
        _value += 1
    }
}

struct SendableView: View {
    @State private var log = DemoLog()
    @State private var isRunning = false
    private let counter = LockedCounter()

    var body: some View {
        DemoScreen(
            title: "Sendable",
            summary: "Sendable types are safe to hand to another Task or actor. Value types get it for free; classes need either actor isolation or manual synchronization.",
            log: log
        ) {
            VStack(alignment: .leading, spacing: 12) {
                Button("Send a Sendable struct into a detached task") {
                    Task { await sendValueType() }
                }

                Button("Hammer the @unchecked Sendable counter (50x)") {
                    Task { await hammerLockedCounter() }
                }
                .disabled(isRunning)

                Button("Run our own @Sendable-closure API") {
                    Task { await runSendableClosureAPI() }
                }
            }
        }
    }

    private func sendValueType() async {
        let report = WeatherReport(city: "Madrid", temperature: 21.5)
        log.append("Created \(report.city): \(report.temperature)° on the main actor.")
        // Safe: WeatherReport is Sendable, so crossing into the detached
        // task below is compiler-checked, not just hoped for.
        let summary = await Task.detached {
            "\(report.city) is \(report.temperature)°"
        }.value
        log.append("Read back from a detached task: \(summary)")
    }

    private func hammerLockedCounter() async {
        isRunning = true
        log.append("Launching 50 concurrent increments on the locked counter…")
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<50 {
                group.addTask {
                    counter.increment()
                }
            }
        }
        log.append("Final value: \(counter.value) — correct only because the lock serializes access.")
        isRunning = false
    }

    private func runSendableClosureAPI() async {
        log.append("Calling performInBackground(_:), whose parameter we declared @Sendable ourselves…")
        let result = await performInBackground {
            // Everything captured or returned here must itself be
            // Sendable — the compiler enforces it against our own
            // `@Sendable` annotation below, the same way it enforces the
            // standard library's on `Task { }`.
            "computed off the main actor: \(6 * 7)"
        }
        log.append("Got back: \(result)")
    }
}

/// An API *we* wrote that hands work to another concurrency domain. Unlike
/// `Task { }`, nothing in the language infers this closure needs to be
/// safe to send — we have to say so explicitly.
private func performInBackground<T: Sendable>(_ work: @Sendable @escaping () async -> T) async -> T {
    await Task.detached {
        await work()
    }.value
}

#Preview {
    NavigationStack { SendableView() }
}
