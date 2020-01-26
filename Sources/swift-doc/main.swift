import TSCUtility
import TSCBasic
import SwiftDoc
import Foundation

struct Options {
  var input: String = ""
  var overrideToolchainPath: AbsolutePath? = nil
  var moduleName: String = "Swift"
  var frameworkSearchPaths: [AbsolutePath] = []
  var librarySearchPaths: [AbsolutePath] = []
  var importSearchPaths: [AbsolutePath] = []
}

do {
  let parser = ArgumentParser(commandName: "swift-doc",
                              usage: "swift doc <term>",
                              overview: "Swift documentation tool",
                              seeAlso: nil)
  let binder = ArgumentBinder<Options>()

  binder.bind(positional: parser.add(positional: "input"),
              to: { $0.input = $1 })
  binder.bind(option: parser.add(option: "-override-toolchain-path",
                                 kind: PathArgument.self),
              to: { $0.overrideToolchainPath = $1.path })
  binder.bind(option: parser.add(option: "-module-name"),
              to: { $0.moduleName = $1 })
  binder.bindArray(option: parser.add(option: "-F",
                                      kind: [PathArgument].self,
                                      strategy: .oneByOne),
                   to: { $0.frameworkSearchPaths = $1.map { $0.path } })
  binder.bindArray(option: parser.add(option: "-L",
                                      kind: [PathArgument].self,
                                      strategy: .oneByOne),
                   to: { $0.librarySearchPaths = $1.map { $0.path } })
  binder.bindArray(option: parser.add(option: "-I",
                                      kind: [PathArgument].self,
                                      strategy: .oneByOne),
                   to: { $0.importSearchPaths = $1.map { $0.path } })


  let parseResult = try parser.parse(Array(CommandLine.arguments.dropFirst()))
  var options = Options()
  try binder.fill(parseResult: parseResult, into: &options)

  let toolPath = try AbsolutePath(validating: CommandLine.arguments[0])
  // Remove "usr/bin/swift-doc"
  let toolchainPath = options.overrideToolchainPath ??
    toolPath.parentDirectory.parentDirectory.parentDirectory
  let toolchain = Toolchain(path: toolchainPath)

  let loader = SymbolGraphLoader(toolchain: toolchain,
                                 frameworkSearchPaths: options.frameworkSearchPaths,
                                 librarySearchPaths: options.librarySearchPaths,
                                 importSearchPaths: options.importSearchPaths)
  let graph = try loader.loadSymbolGraph(for: options.moduleName)

  var index = SymbolIndex()
  index.index(symbolGraph: graph)
  let results = index.lookupSymbol(options.input)
  if !results.isEmpty {
    results[0].0.print(results[0].1, to: stdoutStream)
  } else {
    stdoutStream <<< "No results found for \(options.input) out of \(graph.symbols.count) symbols in module \(options.moduleName)."
    for symbol in graph.symbols {
      print(symbol.displayName)
    }
    stdoutStream.flush()
  }

} catch {
  print("error \(error)")
}
