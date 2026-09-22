Button("Load data (fire-and-forget)") {
    // Task { } is the bridge: it starts new, unstructured async work
    // that keeps running after this synchronous closure returns.
    Task {
        log.append("Task started")
        do {
            let data = try await MockAPI.fetchData(from: "https://example.com/data")
            log.append("Received: \(data)")
        } catch {
            log.append("Failed: \(error)")
        }
    }
    log.append("Button action returned immediately (task keeps running)")
}
