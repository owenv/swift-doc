import TSCBasic

public struct Toolchain {

  let toolchainPath: AbsolutePath

  public init(path: AbsolutePath) {
    self.toolchainPath = path
  }

  public lazy var symbolGraphToolPath: AbsolutePath =
    toolchainPath.appending(components: "usr", "bin", "swift-symbolgraph-extract")
}
