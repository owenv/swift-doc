import ArgumentParser
import TSCBasic
import SwiftDoc

extension AbsolutePath: ExpressibleByArgument {
  public init?(argument: String) {
    try? self.init(validating: argument)
  }
}

struct SwiftDocCommand: ParsableCommand {
  @Option var toolchainPath: AbsolutePath?
  @Option var packagePath: AbsolutePath?

  enum Error: Swift.Error, DiagnosticData {
    case couldNotFindPackageTool
    case couldNotFindPackage

    var description: String {
      switch self {
      case .couldNotFindPackageTool:
        return "could not find swift package tool; try specifying a toolchain with --toolchain-path"
      case .couldNotFindPackage:
        return "could not find Package.swift; try specifying a package root directory with --package-path"
      }
    }
  }

  lazy var defaultToolchainPath: AbsolutePath? =
    try? AbsolutePath(validating: CommandLine.arguments[0]).parentDirectory

  mutating func run() throws {
    let toolchainPath = self.toolchainPath ?? defaultToolchainPath
    let packageToolPath = toolchainPath?.appending(components: "usr", "bin", "swift-package")
    guard let toolPath = packageToolPath, localFileSystem.exists(toolPath) else {
      throw Error.couldNotFindPackageTool
    }
    guard let packagePath = self.packagePath ?? localFileSystem.currentWorkingDirectory,
          localFileSystem.exists(packagePath.appending(component: "Package.swift")) else {
      throw Error.couldNotFindPackage
    }

    let loader = SymbolGraphLoader(packageToolPath: toolPath, packagePath: packagePath)
    try loader.loadSymbolGraphs()
  }
}

let diagnostics = DiagnosticsEngine(handlers: [{ diagnostic in
  let stream = stderrStream
  if !(diagnostic.location is UnknownLocation) {
      stream <<< diagnostic.location.description <<< ": "
  }

  switch diagnostic.message.behavior {
  case .error:
    stream <<< "error: "
  case .warning:
    stream <<< "warning: "
  case .note:
    stream <<< "note: "
  case .remark:
    stream <<< "remark: "
  case .ignored:
      break
  }

  stream <<< diagnostic.localizedDescription <<< "\n"
  stream.flush()
}])

do {
  var command = try SwiftDocCommand.parseAsRoot()
  try command.run()
} catch let error as DiagnosticData {
  diagnostics.emit(.error(error))
} catch {
  print("Unhandled error: \(error.localizedDescription)")
}
