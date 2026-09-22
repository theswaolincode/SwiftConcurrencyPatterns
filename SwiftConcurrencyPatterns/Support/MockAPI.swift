import Foundation

/// A tiny mock backend shared by every pattern example.
///
/// Every member is `nonisolated`, which opts these functions out of this
/// module's default main-actor isolation (`SWIFT_DEFAULT_ACTOR_ISOLATION`)
/// so they genuinely run on the concurrent thread pool while awaited —
/// just like a real network client would.
enum MockAPI {
    struct User: Identifiable, Sendable {
        let id: Int
        let name: String
    }

    struct Profile: Sendable {
        let bio: String
    }

    struct Post: Identifiable, Sendable {
        let id: Int
        let title: String
    }

    struct RequestFailed: Error, Sendable {
        let url: String
    }

    nonisolated static func fetchUsers() async throws -> [User] {
        try await Task.sleep(for: .seconds(1))
        return (1...5).map { User(id: $0, name: "User \($0)") }
    }

    nonisolated static func fetchProfile() async throws -> Profile {
        try await Task.sleep(for: .seconds(1))
        return Profile(bio: "Builds things with Swift 6 structured concurrency.")
    }

    nonisolated static func fetchPosts() async throws -> [Post] {
        try await Task.sleep(for: .seconds(1))
        return (1...3).map { Post(id: $0, title: "Post #\($0)") }
    }

    /// Fetches a single URL. URLs containing "bad" fail, to exercise error handling.
    nonisolated static func fetchData(from url: String) async throws -> String {
        try await Task.sleep(for: .milliseconds(400))
        if url.contains("bad") {
            throw RequestFailed(url: url)
        }
        return "payload(\(url))"
    }

    /// A simulated live feed (socket messages, progress updates, logs…)
    /// exposed as an `AsyncStream` for the AsyncSequence example.
    nonisolated static func messageStream(count: Int = 8) -> AsyncStream<String> {
        AsyncStream { continuation in
            let producer = Task {
                for i in 1...count {
                    try? await Task.sleep(for: .milliseconds(400))
                    continuation.yield("message #\(i)")
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in producer.cancel() }
        }
    }
}
