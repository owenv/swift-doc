import TSCBasic

public struct Toolchain {

  let toolchainPath: AbsolutePath

  public init(path: AbsolutePath) {
    self.toolchainPath = path
  }

  public lazy var diagnosticDocumentationPath: AbsolutePath =
    toolchainPath.appending(components: "usr", "share", "doc", "swift", "diagnostics")
}
