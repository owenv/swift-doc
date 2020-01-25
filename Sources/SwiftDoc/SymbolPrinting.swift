import TSCBasic

extension SymbolGraph.Symbol {
  public func print(to stream: OutputByteStream) {
    let displayName = self.identifier.displayNameComponents.joined(separator: ".")
    let header = "[\(self.kind)] \(displayName)"
    stream <<< header <<< "\n"
    stream <<< String(repeating: "=", count: header.count) <<< "\n"
    for line in self.docComment.lines {
      stream <<< line <<< "\n"
    }
    stream.flush()
  }
}
