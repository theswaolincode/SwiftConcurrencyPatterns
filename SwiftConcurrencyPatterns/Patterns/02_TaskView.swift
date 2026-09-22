import SwiftUI

// MARK: - Pattern 2: Task { }
//
// SwiftUI button actions, `viewDidLoad`, and delegate callbacks are all
// synchronous — they can't be marked `async`. `Task { }` is the bridge: it
// starts new, unstructured concurrent work that runs independently of the
// synchronous caller ("fire-and-forget").

struct TaskView: View {
    @State private var log = DemoLog()

    var body: some View {
        DemoScreen(
            title: "Task { }",
            summary: "A synchronous button action bridges into async work by wrapping it in Task { }.",
            log: log
        ) {
            Button("Load data (fire-and-forget)") {
                // The action closure itself stays synchronous; the Task
                // is what actually performs the async fetch.
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
        }
    }
}

#Preview {
    NavigationStack { TaskView() }
}
