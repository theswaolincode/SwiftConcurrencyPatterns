import SwiftUI

// MARK: - Pattern 3: withTaskGroup
//
// Runs a *dynamic* number of child tasks concurrently and collects their
// results as they finish — ideal when the amount of work isn't known until
// runtime (batch downloads, fanning out over an array of IDs, etc).

struct TaskGroupView: View {
    @State private var log = DemoLog()
    @State private var isLoading = false

    private let urls = [
        "https://example.com/1",
        "https://example.com/2",
        "https://example.com/bad-url",
        "https://example.com/4",
    ]

    var body: some View {
        DemoScreen(
            title: "withTaskGroup",
            summary: "Fans out over \(urls.count) URLs in parallel and collects every result, success or failure, as it arrives.",
            log: log
        ) {
            Button("Fetch all") {
                Task { await fetchAll() }
            }
            .disabled(isLoading)
        }
    }

    private func fetchAll() async {
        isLoading = true
        log.append("Starting \(urls.count) parallel requests…")

        let results = await withTaskGroup(of: (url: String, result: Result<String, Error>).self) { group in
            for url in urls {
                group.addTask {
                    do {
                        let data = try await MockAPI.fetchData(from: url)
                        return (url, .success(data))
                    } catch {
                        return (url, .failure(error))
                    }
                }
            }

            var collected: [(url: String, result: Result<String, Error>)] = []
            for await entry in group {
                collected.append(entry)
                log.append("Finished \(entry.url)")
            }
            return collected
        }

        for entry in results {
            switch entry.result {
            case .success(let data):
                log.append("✅ \(entry.url) -> \(data)")
            case .failure(let error):
                log.append("❌ \(entry.url) -> \(error)")
            }
        }
        isLoading = false
    }
}

#Preview {
    NavigationStack { TaskGroupView() }
}
