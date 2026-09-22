import SwiftUI

// MARK: - Pattern 8: Task Cancellation
//
// Cancellation in Swift concurrency is cooperative: cancelling a `Task`
// only *signals* it. Long-running work must check `Task.checkCancellation()`
// (or `Task.isCancelled`) and stop promptly to save battery and resources —
// production apps should never keep working after they've been told to stop.

struct TaskCancellationView: View {
    @State private var log = DemoLog()
    @State private var runningTask: Task<Void, Never>?

    private var isRunning: Bool { runningTask != nil }

    var body: some View {
        DemoScreen(
            title: "Task Cancellation",
            summary: "Starts a 10-step job. Cancel it mid-flight to see the cooperative check stop it promptly instead of running to completion.",
            log: log
        ) {
            HStack {
                Button("Start job") { start() }
                    .disabled(isRunning)
                Button("Cancel") { runningTask?.cancel() }
                    .disabled(!isRunning)
            }
        }
    }

    private func start() {
        log.append("Job started.")
        runningTask = Task {
            do {
                for step in 1...10 {
                    try Task.checkCancellation()
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
    }
}

#Preview {
    NavigationStack { TaskCancellationView() }
}
