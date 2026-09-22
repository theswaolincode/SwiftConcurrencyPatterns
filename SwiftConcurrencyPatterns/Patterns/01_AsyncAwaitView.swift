import SwiftUI

// MARK: - Pattern 1: async/await
//
// The foundation of modern asynchronous programming.
//   Before: api.fetchUsers { result in switch result { ... } }   (callback hell)
//   After:  let users = try await MockAPI.fetchUsers()           (linear, `try`-based)
//
// Errors propagate with normal `try`/`catch` instead of an extra Result
// parameter, and the compiler tracks exactly where suspension can happen.

struct AsyncAwaitView: View {
    @State private var log = DemoLog()
    @State private var isLoading = false

    var body: some View {
        DemoScreen(
            title: "async / await",
            summary: "Fetches a list of users with a single straight-line call instead of a nested completion handler.",
            log: log
        ) {
            Button("Load users") {
                Task { await loadUsers() }
            }
            .disabled(isLoading)
        }
    }

    private func loadUsers() async {
        isLoading = true
        log.append("Requesting users…")
        do {
            let users = try await MockAPI.fetchUsers()
            log.append("Got \(users.count) users: \(users.map(\.name).joined(separator: ", "))")
        } catch {
            log.append("Failed: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack { AsyncAwaitView() }
}
