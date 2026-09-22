import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Must know") {
                    PatternLink(number: 1, title: "async / await", subtitle: "Replaces callback hell with linear, readable code.") {
                        AsyncAwaitView()
                    }
                    PatternLink(number: 2, title: "Task { }", subtitle: "Bridges synchronous code into async work.") {
                        TaskView()
                    }
                    // ...withTaskGroup, async let
                }

                Section("Understand deeply") {
                    // @MainActor, Actors, Sendable
                }

                Section("Production-ready") {
                    // AsyncSequence, Task Cancellation
                }
            }
            .navigationTitle("Swift 6 Concurrency")
        }
    }
}
