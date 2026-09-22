streamTask = Task {
    // `for await` pulls one value at a time as it arrives — nothing is
    // buffered up front, and this loop suspends between messages.
    for await message in MockAPI.messageStream() {
        log.append("📩 \(message)")
    }
    log.append("Feed finished.")
    streamTask = nil
}
