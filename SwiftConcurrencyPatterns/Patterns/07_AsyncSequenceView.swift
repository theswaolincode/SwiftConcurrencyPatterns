import SwiftUI

// MARK: - Pattern 7: AsyncSequence
//
// Models a stream of values that arrive over time — socket messages, a live
// feed, progress updates, log lines — as something you can `for await` over,
// just like iterating a normal Sequence. Values are handled as they arrive
// instead of buffering the whole feed in memory.

struct AsyncSequenceView: View {
    @State private var log = DemoLog()
    @State private var streamTask: Task<Void, Never>?

    var body: some View {
        DemoScreen(
            title: "AsyncSequence",
            summary: "Simulates a live message feed. Each message is consumed as soon as it arrives.",
            log: log
        ) {
            HStack {
                Button("Start feed") {
                    startListening()
                }
                .disabled(streamTask != nil)

                Button("Stop") {
                    streamTask?.cancel()
                    streamTask = nil
                    log.append("Stopped listening.")
                }
                .disabled(streamTask == nil)
            }
        }
        .onDisappear { streamTask?.cancel() }
    }

    private func startListening() {
        log.append("Subscribing to message feed…")
        streamTask = Task {
            for await message in MockAPI.messageStream() {
                log.append("📩 \(message)")
            }
            log.append("Feed finished.")
            streamTask = nil
        }
    }
}

#Preview {
    NavigationStack { AsyncSequenceView() }
}
