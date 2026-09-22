runningTask = Task {
    for step in 1...10 {
        // Nothing stops automatically when `.cancel()` is called — the
        // task itself has to check.
        try await Task.sleep(for: .milliseconds(400))
        log.append("Step \(step)/10 complete")
    }
}
// Tapping Cancel here would flag the task, but this loop would run to
// completion anyway — cancellation is cooperative, not forced.
