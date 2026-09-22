import SwiftUI

// MARK: - Pattern 4: async let
//
// Runs a *fixed, known* number of async operations concurrently with almost
// no ceremony. Each `async let` starts immediately; awaiting the bindings
// later just joins work that's already in flight.

struct AsyncLetView: View {
    @State private var log = DemoLog()
    @State private var isLoading = false

    var body: some View {
        DemoScreen(
            title: "async let",
            summary: "Loads a profile and its posts at the same time, then combines both once both are ready.",
            log: log
        ) {
            Button("Load profile screen") {
                Task { await loadProfileScreen() }
            }
            .disabled(isLoading)
        }
    }

    private func loadProfileScreen() async {
        isLoading = true
        log.append("Starting profile + posts concurrently…")

        async let profile = MockAPI.fetchProfile()
        async let posts = MockAPI.fetchPosts()

        do {
            // Both requests are already running; this just joins them.
            let (loadedProfile, loadedPosts) = try await (profile, posts)
            log.append("Bio: \(loadedProfile.bio)")
            log.append("Posts: \(loadedPosts.map(\.title).joined(separator: ", "))")
        } catch {
            log.append("Failed: \(error)")
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack { AsyncLetView() }
}
