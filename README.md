# SwiftDoc - Experimental tool for Swift documentation generation via symbol graph dumps

This package consists of a library, `SwiftDoc`, for working with the documentation of a Swift module and a CLI tool, `swift-doc`, which acts as a frontend. `swift-doc` is intended to be installed in and used with a full swift toolchain. It uses the experimental `swift-symbolgraph-extract` tool to read information about Swift symbols.

## Building

Currently, `SwiftDoc` is a straightforward SwiftPM project. Just clone the repo and run `swift build`, or open `Package.swift` in Xcode.

## Using `swift-doc`

Currently, swift-doc only works with SwiftPM packages. Supported options are:

- `--toolchain-path`: Path to a Swift toolchain. If this is not provided, the tool will assume it is installed inside a toolchain.
- `--package-path`: The root path of a SwiftPM package to generate docs for. If this is not provided, the tool will fallback to looking in the current working directory.

## Current status

Currently, the tool only supports generating and reading symbol graph output and does not generate any outputs. The next step is to begin writing backends for automatic documentation generation.
