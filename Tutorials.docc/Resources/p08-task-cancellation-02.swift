runningTask = Task {
    do {
        for step in 1...10 {
            try Task.checkCancellation() // throws CancellationError if cancelled
            try await Task.sleep(for: .milliseconds(400))
            log.append("Step \(step)/10 complete")
        }
        log.append("Job finished ✅")
    } catch is CancellationError {
        log.append("Job cancelled before completion ⛔️")
    } catch {
        log.append("Job failed: \(error)")
    }
    runningTask = nil
}
