async let profile = MockAPI.fetchProfile()
async let posts = MockAPI.fetchPosts()
// Both requests start immediately, right here — before either is awaited.
