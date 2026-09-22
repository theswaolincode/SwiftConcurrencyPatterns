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
