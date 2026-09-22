await withTaskGroup(of: Void.self) { group in
    for i in 0..<50 {
        group.addTask {
            // Every call is `await`-ed: each of the 50 tasks waits its
            // turn to enter the actor instead of racing to mutate storage.
            await cache.store("value-\(i)", for: "key-\(i % 5)")
        }
    }
}

let finalCount = await cache.writeCount
log.append("Final value: \(finalCount)") // always exactly 50
