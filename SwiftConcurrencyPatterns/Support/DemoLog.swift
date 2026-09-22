import Foundation
import Observation

/// A timestamped, on-screen log so each pattern's async behavior is visible
/// as it happens instead of only as a final result.
@MainActor
@Observable
final class DemoLog {
    private(set) var lines: [String] = []
    private var startDate = Date()

    func append(_ message: String) {
        let elapsed = Date().timeIntervalSince(startDate)
        lines.append(String(format: "[%5.2fs] %@", elapsed, message))
    }

    func clear() {
        lines.removeAll()
        startDate = Date()
    }
}
