# Swift Concurrency Patterns

A learning project: 9 runnable SwiftUI demos covering the Swift concurrency patterns every iOS developer should know, built in full **Swift 6 language mode** with strict concurrency checking on.

This isn't just a reference — it's meant to be used. Each pattern is its own screen: tap a button, watch a timestamped log show the async behavior as it actually happens (things finishing out of order, cancellation cutting a job short, 50 writers hitting one actor without corrupting it). Read the code alongside the log output to see *why* it behaves that way.

`ContentView` groups all 9 the way they're best learned, in order:

1. **Must know** — `async`/`await`, `Task { }`, `withTaskGroup`, `async let`
2. **Understand deeply** — `@MainActor`, `actor`, `Sendable`
3. **Production-ready** — `AsyncSequence`, Task Cancellation

## Patterns: how they work and when to reach for them

### 1. `async`/`await` — [`01_AsyncAwaitView.swift`](SwiftConcurrencyPatterns/Patterns/01_AsyncAwaitView.swift)
**How it works:** a function marked `async` can suspend at an `await` point without blocking the thread; execution resumes later, wherever the runtime decides is appropriate. Errors propagate with normal `try`/`catch` instead of a `Result` parameter.
**When to use it:** the default for any single asynchronous call — a network request, a disk read, anything you'd have used a completion handler for. It's the foundation every other pattern here is built on.

### 2. `Task { }` — [`02_TaskView.swift`](SwiftConcurrencyPatterns/Patterns/02_TaskView.swift)
**How it works:** creates new, unstructured concurrent work from a synchronous context. It starts running independently and keeps going even after the code that created it returns.
**When to use it:** whenever you need to call `async` code from somewhere that *can't* be `async` — a SwiftUI button action, `viewDidLoad`, a delegate callback. It's the bridge between sync and async worlds, not something you nest async code inside of once you're already in an async context.

### 3. `withTaskGroup` — [`03_TaskGroupView.swift`](SwiftConcurrencyPatterns/Patterns/03_TaskGroupView.swift)
**How it works:** spins up a *dynamic* number of child tasks that run concurrently, then lets you collect their results as each one finishes (in completion order, not start order).
**When to use it:** when the amount of concurrent work isn't known until runtime — fetching N items from an array of IDs, batch downloads, processing a variable-size list in parallel. If you don't know `N` ahead of time, this is the tool.

### 4. `async let` — [`04_AsyncLetView.swift`](SwiftConcurrencyPatterns/Patterns/04_AsyncLetView.swift)
**How it works:** binds the result of an async call to a constant that starts running immediately; the actual `await` happens later, when you read the value. Multiple `async let`s declared together all run concurrently.
**When to use it:** when you know exactly how many independent async calls you need — usually 2 or 3, hardcoded — and just want to run them in parallel and join the results, e.g. loading a profile and its posts at the same time before rendering one screen. For a *variable* number of calls, use `withTaskGroup` instead.

### 5. `@MainActor` — [`05_MainActorView.swift`](SwiftConcurrencyPatterns/Patterns/05_MainActorView.swift)
**How it works:** pins a type, property, or function to the main actor. The compiler then *proves* — not just hopes — that its state is only ever touched from the main thread, rejecting any code path that could mutate it off the main thread.
**When to use it:** on view models and any other state that drives UI. It replaces the old runtime crash/warning ("Publishing changes from background threads") with a compile-time guarantee, so the bug never ships.

### 6. `actor` — [`06_ActorView.swift`](SwiftConcurrencyPatterns/Patterns/06_ActorView.swift)
**How it works:** an `actor` serializes access to its own mutable state — only one task can be executing inside it at a time. Concurrent callers each `await` their turn instead of racing.
**When to use it:** for shared mutable state that many tasks read and write concurrently and that isn't naturally tied to the main thread — a cache, a connection pool, an in-memory store. Where `@MainActor` says "only the main thread may touch this," `actor` says "only one caller at a time may touch this, whoever that is."

### 9. `Sendable` — [`09_SendableView.swift`](SwiftConcurrencyPatterns/Patterns/09_SendableView.swift)
**How it works:** `Sendable` marks a type as safe to pass across concurrency domains — into a `Task`, an `actor`, another thread — without risking a data race. A `struct`/`enum` gets it for free once every stored property is itself `Sendable`. A `class` doesn't: two references to the same instance could be mutated from two places at once, so the compiler refuses to let a non-Sendable class cross into a `@Sendable` closure. You either make it an `actor` (Pattern 6, preferred) or manually synchronize it yourself and mark it `@unchecked Sendable` as a promise to the compiler. The `@Sendable` *attribute* is the closure-level version of the same idea — you rarely write it yourself when calling `Task { }`, since the standard library already declares those parameters as sendable, but you do need it when authoring your own API that hands a closure to another concurrency domain.
**When to use it:** think about it every time a value needs to cross from one actor/task to another — which is constantly, since almost every pattern above involves a boundary. It's less a pattern you "reach for" and more the safety property the compiler is checking for you throughout all the others.

### 7. `AsyncSequence` — [`07_AsyncSequenceView.swift`](SwiftConcurrencyPatterns/Patterns/07_AsyncSequenceView.swift)
**How it works:** models a sequence of values that arrive over time, consumed with `for await` exactly like iterating a normal `Sequence` — except each element is produced (and can be awaited) one at a time instead of all being available up front.
**When to use it:** streaming data — WebSocket messages, live feeds, progress updates, log lines. Anything where you'd otherwise have wired up a callback per event, and where buffering everything in memory before processing would be wasteful or impossible (an infinite stream).

### 8. Task Cancellation — [`08_TaskCancellationView.swift`](SwiftConcurrencyPatterns/Patterns/08_TaskCancellationView.swift)
**How it works:** cancellation is cooperative — calling `.cancel()` on a `Task` only *flags* it. The work itself has to check `Task.checkCancellation()` (throws) or `Task.isCancelled` and stop on its own; nothing is forced to stop.
**When to use it:** any long-running or resumable work that the user might navigate away from or explicitly cancel — a search-as-you-type request, a large upload, a multi-step job. Production code should always check cancellation periodically in loops so abandoned work doesn't keep burning CPU and battery.

## Project layout

```
SwiftConcurrencyPatterns/
├── ContentView.swift        # navigation hub listing all 9 patterns
├── MyApp.swift               # app entry point
├── Support/
│   ├── MockAPI.swift          # shared fake network layer used by every demo
│   ├── DemoLog.swift          # timestamped, on-screen log
│   └── DemoScreen.swift       # shared demo screen chrome (summary + controls + log)
└── Patterns/
    ├── 01_AsyncAwaitView.swift
    ├── 02_TaskView.swift
    ├── 03_TaskGroupView.swift
    ├── 04_AsyncLetView.swift
    ├── 05_MainActorView.swift
    ├── 06_ActorView.swift
    ├── 07_AsyncSequenceView.swift
    ├── 08_TaskCancellationView.swift
    └── 09_SendableView.swift
```

## Requirements

- Xcode 26.3+
- Swift 6 language mode (already set in the project's build settings)
- iOS / macOS / visionOS SDK 27+

## Running it

Open `SwiftConcurrencyPatterns.xcodeproj` in Xcode and run the app on any simulator or device target. Each list row pushes to a live demo — start it, read the log as it fills in, and for pattern 8 try tapping Cancel mid-run to see cooperative cancellation actually cut the work short.

## Step-by-step tutorial

The `tutorial` branch adds `Tutorials.docc` — a DocC Tutorials catalog in the same format as Apple's own [App Dev Training tutorials](https://developer.apple.com/tutorials/app-dev-training), covering all 9 patterns as chaptered, step-by-step lessons with real code snapshots from this project.

To read it, either:

- **From Xcode**: select the **`PreviewTutorial`** scheme and press **⌘B** (Build). The first time, macOS will ask permission for Xcode to control Terminal — allow it. It opens a Terminal window running the preview server, then opens your browser to the table of contents.
- **From a terminal**:
  ```bash
  ./preview-tutorial.sh
  ```
  then open `http://localhost:8080/tutorials/table-of-contents`.

Don't run plain `xcrun docc preview` — without the flags this script passes, DocC generates a broken bundle identifier and every chapter/tutorial link silently fails to navigate.

Opening the `Tutorials.docc` folder directly in Xcode (File ▸ Open) lets you edit it, but as of this Xcode beta the live in-Xcode preview canvas doesn't activate for a catalog that isn't wired into a project target — use one of the options above to actually read it rendered.
