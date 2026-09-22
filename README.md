# Swift Concurrency Patterns

A runnable SwiftUI catalog of the 8 Swift concurrency patterns every iOS developer should know, built in full **Swift 6 language mode** with strict concurrency checking on.

Each pattern is its own screen: tap a button, watch a timestamped log show the async behavior as it actually happens.

## Patterns

| # | Pattern | File | What it shows |
|---|---------|------|----------------|
| 1 | `async`/`await` | [`01_AsyncAwaitView.swift`](SwiftConcurrencyPatterns/Patterns/01_AsyncAwaitView.swift) | Linear `try await` code replacing nested completion handlers |
| 2 | `Task { }` | [`02_TaskView.swift`](SwiftConcurrencyPatterns/Patterns/02_TaskView.swift) | Bridging a synchronous button action into async work |
| 3 | `withTaskGroup` | [`03_TaskGroupView.swift`](SwiftConcurrencyPatterns/Patterns/03_TaskGroupView.swift) | Fanning out over a dynamic list of URLs in parallel |
| 4 | `async let` | [`04_AsyncLetView.swift`](SwiftConcurrencyPatterns/Patterns/04_AsyncLetView.swift) | Running a fixed number of concurrent calls and joining the results |
| 5 | `@MainActor` | [`05_MainActorView.swift`](SwiftConcurrencyPatterns/Patterns/05_MainActorView.swift) | A view model whose state is compiler-guaranteed to update on the main thread |
| 6 | `actor` | [`06_ActorView.swift`](SwiftConcurrencyPatterns/Patterns/06_ActorView.swift) | 50 concurrent writers hammering a shared cache with zero lost updates |
| 7 | `AsyncSequence` | [`07_AsyncSequenceView.swift`](SwiftConcurrencyPatterns/Patterns/07_AsyncSequenceView.swift) | Consuming a live message feed with `for await` |
| 8 | Task Cancellation | [`08_TaskCancellationView.swift`](SwiftConcurrencyPatterns/Patterns/08_TaskCancellationView.swift) | Cooperative cancellation via `Task.checkCancellation()` |

`ContentView` lists all eight, grouped the way the source poster recommends learning them: **Must know** → **Understand deeply** → **Production-ready**.

## Project layout

```
SwiftConcurrencyPatterns/
├── ContentView.swift        # navigation hub listing all 8 patterns
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
    └── 08_TaskCancellationView.swift
```

## Requirements

- Xcode 26.3+
- Swift 6 language mode (already set in the project's build settings)
- iOS / macOS / visionOS SDK 27+

## Running it

Open `SwiftConcurrencyPatterns.xcodeproj` in Xcode and run the app on any simulator or device target. Each list row pushes to a live demo — start, watch the log, and (for pattern 8) try cancelling mid-run.
