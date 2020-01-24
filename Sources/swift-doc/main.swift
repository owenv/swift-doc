import TSCUtility
import TSCBasic
import SwiftDoc

struct Options {
  var input: String = ""
  var overrideToolchainPath: AbsolutePath? = nil
}

do {
  let parser = ArgumentParser(commandName: "swift-doc",
                              usage: "swift doc <term>",
                              overview: "Swift documentation tool",
                              seeAlso: nil)
  let binder = ArgumentBinder<Options>()

  binder.bind(positional: parser.add(positional: "input"),
              to: { $0.input = $1 })
  binder.bind(option: parser.add(option: "--override-toolchain-path",
                                 kind: PathArgument.self),
              to: { $0.overrideToolchainPath = $1.path })

  let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))
  var options = Options()
  try binder.fill(parseResult: result, into: &options)

  let toolPath = try AbsolutePath(validating: CommandLine.arguments[0])
  // Remove "usr/bin/swift-doc"
  let toolchainPath = options.overrideToolchainPath ??
    toolPath.parentDirectory.parentDirectory.parentDirectory
  var toolchain = Toolchain(path: toolchainPath)

}
