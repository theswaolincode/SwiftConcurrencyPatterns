import SwiftUI

// MARK: - Pattern 5: @MainActor
//
// Pins a type to the main actor so the compiler *guarantees* its state is
// only ever touched from the main thread — no "Publishing changes from
// background threads" bugs, checked at compile time instead of discovered
// at runtime.

@MainActor
@Observable
final class DashboardViewModel {
    private(set) var statusText = "Idle"
    private(set) var isRefreshing = false

    func refresh() async {
        isRefreshing = true
        statusText = "Refreshing…" // Always safe: this line always runs on the main actor.

        // `fetchUsers` is `nonisolated` and hops off the main actor while it
        // awaits its simulated delay, then execution resumes back here.
        let users = try? await MockAPI.fetchUsers()

        statusText = "Loaded \(users?.count ?? 0) users"
        isRefreshing = false
    }
}

struct MainActorView: View {
    @State private var viewModel = DashboardViewModel()
    @State private var log = DemoLog()

    var body: some View {
        DemoScreen(
            title: "@MainActor",
            summary: "DashboardViewModel is @MainActor: every property read/write is compiler-checked to happen on the main thread.",
            log: log
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.statusText)
                    .font(.headline)
                Button("Refresh") {
                    Task {
                        await viewModel.refresh()
                        log.append("View model reports: \(viewModel.statusText)")
                    }
                }
                .disabled(viewModel.isRefreshing)
            }
        }
    }
}

#Preview {
    NavigationStack { MainActorView() }
}
