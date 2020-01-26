import TSCBasic
import Foundation

public struct SymbolGraphLoader {
  var toolchain: Toolchain

  public init(toolchain: Toolchain) {
    self.toolchain = toolchain
  }

  public func loadSymbolGraph(for moduleName: String) throws -> SymbolGraph {
    let targetInfo = try toolchain.hostTargetInfo()

    var symbolGraphArguments = [toolchain.symbolGraphToolPath.pathString]
    symbolGraphArguments += ["-target", targetInfo.target.triple]
    if let sdk = targetInfo.paths.sdkPath {
      symbolGraphArguments += ["-sdk", sdk]
    }
    for importPath in targetInfo.paths.runtimeLibraryImportPaths {
      symbolGraphArguments += ["-L", importPath]
    }
    symbolGraphArguments += ["-module-name", "Swift"]
    symbolGraphArguments += ["-o", "-"]

    let process = TSCBasic.Process(arguments: symbolGraphArguments)
    try process.launch()
    let processResult = try process.waitUntilExit()
    let output = try processResult.output.get()
    
    return try JSONDecoder().decode(SymbolGraph.self, from: Data(output))
  }
}
