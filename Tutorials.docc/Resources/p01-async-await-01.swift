enum MockAPI {
    struct User: Identifiable, Sendable {
        let id: Int
        let name: String
    }

    nonisolated static func fetchUsers() async throws -> [User] {
        try await Task.sleep(for: .seconds(1))
        return (1...5).map { User(id: $0, name: "User \($0)") }
    }
}
