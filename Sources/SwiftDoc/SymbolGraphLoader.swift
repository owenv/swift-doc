import TSCBasic
import Foundation

public struct SymbolGraphLoader {
  var packageToolPath: AbsolutePath
  var packagePath: AbsolutePath

  enum Error: Swift.Error {
    case dumpSymbolGraphFailed
    case couldNotDetermineOutputPath
  }

  public init(packageToolPath: AbsolutePath, packagePath: AbsolutePath) {
    self.packageToolPath = packageToolPath
    self.packagePath = packagePath
  }

  public func loadSymbolGraphs() throws {
    let commandLine = [packageToolPath.pathString, "--package-path", packagePath.pathString, "dump-symbol-graph"]
    let process = Process(arguments: commandLine,
                          outputRedirection: .collect)
    try process.launch()
    let result = try process.waitUntilExit()
    guard result.exitStatus == .terminated(code: 0) else {
      throw Error.dumpSymbolGraphFailed
    }
    let output = try result.utf8Output()
    guard let lastLine = output.split(separator: "\n").last,
          lastLine.hasPrefix("Files written to "),
          let outputPath = try? AbsolutePath(validating: String(lastLine.dropFirst(17))) else {
      throw Error.couldNotDetermineOutputPath
    }

    let decoder = JSONDecoder()
    for item in try localFileSystem.getDirectoryContents(outputPath) {
      let symbolGraphPath = outputPath.appending(component: item)
      do {
        let data = Data(try localFileSystem.readFileContents(symbolGraphPath).contents)
        let symbolGraph = try decoder.decode(SymbolGraph.self, from: data)
      } catch {
        print(error)
      }
    }
  }
}
