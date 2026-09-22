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
