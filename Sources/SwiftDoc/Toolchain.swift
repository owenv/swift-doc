import TSCBasic
import TSCUtility
import Foundation

public struct Toolchain {
  let toolchainPath: AbsolutePath
  public var symbolGraphToolPath: AbsolutePath
  public var swiftCompilerPath: AbsolutePath

  public init(path: AbsolutePath) {
    self.toolchainPath = path
    symbolGraphToolPath = toolchainPath.appending(components: "usr", "bin", "swift-symbolgraph-extract")
    swiftCompilerPath = toolchainPath.appending(components: "usr", "bin", "swift")
  }

  public func hostTargetInfo() throws -> TargetInfo {
    let result = try Process.checkNonZeroExit(
      arguments: [swiftCompilerPath.pathString, "-print-target-info"]).spm_chomp()
    return try JSONDecoder().decode(TargetInfo.self, from: result.data(using: .utf8)!)
  }
}

public struct Target: Codable {
  /// The target triple.
  public var triple: String
  /// The target triple, without a version.
  public var unversionedTriple: String
  /// The triple used for module file names.
  public var moduleTriple: String
  /// If this platform provides the Swift runtime, the Swift language version
  /// with which that runtime is compatible.
  public var swiftRuntimeCompatibilityVersion: String?
  /// Whether linking against the Swift libraries requires the use of rpaths.
  public var librariesRequireRPath: Bool
}

public struct Paths: Codable {
  public var sdkPath: String?
  public var runtimeResourcePath: String
  public var runtimeLibraryPaths: [String]
  public var runtimeLibraryImportPaths: [String]
}

public struct TargetInfo: Codable {
  public var target: Target
  public var paths: Paths
}
