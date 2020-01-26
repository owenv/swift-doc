import TSCBasic
import Foundation

public struct SymbolGraphLoader {
  var toolchain: Toolchain
  var frameworkSearchPaths: [AbsolutePath]
  var librarySearchPaths: [AbsolutePath]
  var importSearchPaths: [AbsolutePath]

  public init(toolchain: Toolchain,
              frameworkSearchPaths: [AbsolutePath],
              librarySearchPaths: [AbsolutePath],
              importSearchPaths: [AbsolutePath]) {
    self.toolchain = toolchain
    self.frameworkSearchPaths = frameworkSearchPaths
    self.librarySearchPaths = librarySearchPaths
    self.importSearchPaths = importSearchPaths
  }

  public func loadSymbolGraph(for moduleName: String) throws -> SymbolGraph {
    let targetInfo = try toolchain.hostTargetInfo()

    var symbolGraphArguments = [toolchain.symbolGraphToolPath.pathString]
    symbolGraphArguments += ["-target", targetInfo.target.triple]
    if let sdk = targetInfo.paths.sdkPath {
      symbolGraphArguments += ["-sdk", sdk]
    }
    for path in frameworkSearchPaths {
      symbolGraphArguments += ["-F", path.pathString]
    }
    for path in librarySearchPaths {
      symbolGraphArguments += ["-L", path.pathString]
    }
    for importPath in targetInfo.paths.runtimeLibraryImportPaths + importSearchPaths.map({ $0.pathString }) {
      symbolGraphArguments += ["-I", importPath]
    }
    symbolGraphArguments += ["-module-name", moduleName]
    symbolGraphArguments += ["-o", "-"]
    print(symbolGraphArguments.joined(separator: " "))
    let process = TSCBasic.Process(arguments: symbolGraphArguments)
    try process.launch()
    let processResult = try process.waitUntilExit()
    let output = try processResult.output.get()
    
    return try JSONDecoder().decode(SymbolGraph.self, from: Data(output))
  }
}
