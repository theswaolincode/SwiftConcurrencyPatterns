import SwiftUI

// MARK: - Pattern 6: actor
//
// An `actor` serializes access to its own mutable state: only one task at a
// time may be executing inside it. That eliminates data races on shared
// state without manual locks — a plain `class` here would risk lost updates
// under concurrent writes.

actor CacheManager {
    private var storage: [String: String] = [:]
    private(set) var writeCount = 0

    func value(for key: String) -> String? {
        storage[key]
    }

    func store(_ value: String, for key: String) {
        storage[key] = value
        writeCount += 1
    }
}

struct ActorView: View {
    private let cache = CacheManager()
    @State private var log = DemoLog()
    @State private var isRunning = false

    var body: some View {
        DemoScreen(
            title: "Actors",
            summary: "50 tasks write to the same cache concurrently. The actor serializes access, so writeCount always ends up exactly 50 — no lost updates.",
            log: log
        ) {
            Button("Hammer the cache with 50 concurrent writes") {
                Task { await hammerCache() }
            }
            .disabled(isRunning)
        }
    }

    private func hammerCache() async {
        isRunning = true
        log.append("Launching 50 concurrent writers…")

        await withTaskGroup(of: Void.self) { group in
            for i in 0..<50 {
                group.addTask {
                    await cache.store("value-\(i)", for: "key-\(i % 5)")
                }
            }
        }

        let finalCount = await cache.writeCount
        log.append("All writes finished. writeCount == \(finalCount)")
        isRunning = false
    }
}

#Preview {
    NavigationStack { ActorView() }
}
