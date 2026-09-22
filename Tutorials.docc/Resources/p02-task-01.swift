// A SwiftUI button action is a plain, synchronous closure.
// It cannot be marked `async`, so it cannot `await` anything directly:

Button("Load data") {
    let data = try await MockAPI.fetchData(from: "https://example.com/data") // ❌ 'await' in a non-async context
}
