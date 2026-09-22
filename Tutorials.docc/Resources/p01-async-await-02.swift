struct AsyncAwaitView: View {
    @State private var log = DemoLog()
    @State private var isLoading = false

    var body: some View {
        DemoScreen(title: "async / await", summary: "...", log: log) {
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
