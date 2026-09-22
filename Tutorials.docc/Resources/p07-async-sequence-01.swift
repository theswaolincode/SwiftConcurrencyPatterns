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
