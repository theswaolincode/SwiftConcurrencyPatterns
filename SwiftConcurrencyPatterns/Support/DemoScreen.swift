import SwiftUI

/// Common chrome for every pattern demo: a short explanation, the controls
/// that trigger the async work, and a live output log.
struct DemoScreen<Controls: View>: View {
    let title: String
    let summary: String
    let log: DemoLog
    @ViewBuilder var controls: Controls

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(summary)
                    .font(.callout)
                    .foregroundStyle(.secondary)

                controls

                Divider()

                HStack {
                    Text("Output")
                        .font(.headline)
                    Spacer()
                    Button("Clear", role: .destructive) { log.clear() }
                        .font(.caption)
                }

                VStack(alignment: .leading, spacing: 4) {
                    if log.lines.isEmpty {
                        Text("Run the demo above to see it in action.")
                            .font(.system(.footnote, design: .monospaced))
                            .foregroundStyle(.tertiary)
                    }
                    ForEach(Array(log.lines.enumerated()), id: \.offset) { _, line in
                        Text(line)
                            .font(.system(.footnote, design: .monospaced))
                    }
                }
            }
            .padding()
        }
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
