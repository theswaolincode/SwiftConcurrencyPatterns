actor CacheManager {
    private var storage: [String: String] = [:]
    private(set) var writeCount = 0

    func store(_ value: String, for key: String) {
        storage[key] = value
        writeCount += 1
    }
}
// Only one task at a time can be executing inside an actor's methods —
// that's what makes `writeCount += 1` safe under concurrent callers.
