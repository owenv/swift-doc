# SwiftDoc

This package consists of a library, `SwiftDoc`, for working with the documentation of a Swift module and a CLI tool, `swift-doc`, for querying that information. `swift-doc` is intended to be installed in and used with a full swift toolchain. It uses the experimental `swift-symbolgraph-extract` tool to read information about Swift symbols from serialized modules without needing to perform a compile.

## Building

Currently, `SwiftDoc` is a straightforward SwiftPM project. Just clone the repo and run `swift build`, or open `Package.swift` in Xcode.

## Using `swift-doc`

### Option 1: Toolchain Installation

1. Copy the swift-doc binary to `<Path to Swift Toolchain>/usr/bin/`, next to `swift`
2. Invoke `swift-doc` as a compiler subcommand, e.g. `swift doc <symbol name>`

### Option 2: Testing/Debugging

1. Invoke the build `swift-doc` binary as `swift-doc <symbol name> --override-toolchain-path <Path to Swift Toolchain>`

__Note:__ In both cases, `<Path to Swift Toolchain>` must point to a toolchain from a  [trunk development snapshot from swift.org](https://swift.org/download/#snapshots). Older Swift versions do not include the `swift-symbolgraph-extract` tool.

TODO:
- [ ] `swift-symbolgraph-extract` output contains a lot of valuable information that isn't being deserialized yet, and could be used to improve output quality.
- [ ] Support fetching documentation for modules other than the standard library
- [ ] Proper indexing and search, including fuzzy matching
- [ ] Better markdown formatting for doc comments in the terminal
