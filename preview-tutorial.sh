#!/bin/bash
# Runs the DocC tutorial preview server with the flags it actually needs.
# Plain `xcrun docc preview` (no args) generates broken internal links —
# see Tutorials.docc's README note. Ctrl+C to stop.
set -euo pipefail
cd "$(dirname "$0")"
exec xcrun docc preview Tutorials.docc \
  --fallback-display-name "Swift 6 Concurrency Patterns" \
  --fallback-bundle-identifier com.example.SwiftConcurrencyPatterns.Tutorials \
  --fallback-bundle-version 1.0
