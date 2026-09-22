async let profile = MockAPI.fetchProfile()
async let posts = MockAPI.fetchPosts()

do {
    // Both requests were already running; this just joins them.
    let (loadedProfile, loadedPosts) = try await (profile, posts)
    log.append("Bio: \(loadedProfile.bio)")
    log.append("Posts: \(loadedPosts.map(\.title).joined(separator: ", "))")
} catch {
    log.append("Failed: \(error)")
}
