import TSCUtility
import TSCBasic
import SwiftDoc
import Foundation

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

  let parseResult = try parser.parse(Array(CommandLine.arguments.dropFirst()))
  var options = Options()
  try binder.fill(parseResult: parseResult, into: &options)

  let toolPath = try AbsolutePath(validating: CommandLine.arguments[0])
  // Remove "usr/bin/swift-doc"
  let toolchainPath = options.overrideToolchainPath ??
    toolPath.parentDirectory.parentDirectory.parentDirectory
  var toolchain = Toolchain(path: toolchainPath)

  // TODO: stop hardcoding the module name and target triple
  let process = TSCBasic.Process(arguments: [toolchain.symbolGraphToolPath.pathString, "-target", "x86_64-apple-darwin19.3.0", "-module-name", "Swift", "-o", "-"])
  try process.launch()
  let processResult = try process.waitUntilExit()
  let output = try processResult.output.get()


  let decoder = JSONDecoder()
  let graph = try decoder.decode(SymbolGraph.self, from: Data(output))
  var index = SymbolIndex()
  index.index(symbolGraph: graph)

  let results = index.lookupSymbol(options.input)
  if !results.isEmpty {
    results[0].0.print(results[0].1, to: stdoutStream)
  } else {
    stdoutStream <<< "No results found for \(options.input)"
  }

} catch {
  print("error \(error)")
}
