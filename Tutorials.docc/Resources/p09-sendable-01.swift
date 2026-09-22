// A struct/enum gets Sendable for free once every stored property is
// itself Sendable — there's nothing to race on with value semantics.
struct WeatherReport: Sendable {
    let city: String
    let temperature: Double
}

// A class does NOT get this for free:
final class Counter {
    var value = 0
}

Task.detached {
    counter.value += 1   // ❌ error: capture of 'counter' with non-sendable
}                          //    type 'Counter' in a '@Sendable' closure
