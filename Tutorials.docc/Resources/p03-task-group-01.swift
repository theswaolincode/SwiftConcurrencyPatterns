private let urls = [
    "https://example.com/1",
    "https://example.com/2",
    "https://example.com/bad-url",
    "https://example.com/4",
]
// The number of URLs isn't fixed in the language — it could come from a
// server response. `withTaskGroup` is what scales to that.
