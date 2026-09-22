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
                    PatternLink(number: 3, title: "withTaskGroup", subtitle: "Runs a dynamic number of tasks in parallel.") {
                        TaskGroupView()
                    }
                    PatternLink(number: 4, title: "async let", subtitle: "Runs a fixed number of async calls concurrently.") {
                        AsyncLetView()
                    }
                }

                Section("Understand deeply") {
                    PatternLink(number: 5, title: "@MainActor", subtitle: "Compiler-enforced main-thread UI updates.") {
                        MainActorView()
                    }
                    PatternLink(number: 6, title: "Actors", subtitle: "Protects shared mutable state without locks.") {
                        ActorView()
                    }
                    PatternLink(number: 9, title: "Sendable", subtitle: "Marks types safe to cross concurrency domains.") {
                        SendableView()
                    }
                }

                Section("Production-ready") {
                    PatternLink(number: 7, title: "AsyncSequence", subtitle: "Streams values over time with for-await.") {
                        AsyncSequenceView()
                    }
                    PatternLink(number: 8, title: "Task Cancellation", subtitle: "Cooperative cancellation for long-running work.") {
                        TaskCancellationView()
                    }
                }
            }
            .navigationTitle("Swift 6 Concurrency")
        }
    }
}

private struct PatternLink<Destination: View>: View {
    let number: Int
    let title: String
    let subtitle: String
    @ViewBuilder var destination: () -> Destination

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Text("\(number)")
                    .font(.headline)
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(.blue.opacity(0.15)))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline)
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
