import TSCBasic

extension SymbolGraph {
  public func print(_ symbol: Symbol, to stream: OutputByteStream) {
    let header = "[\(symbol.kind)] \(symbol.displayName)"
    stream <<< header <<< "\n"
    var separatorLength = header.count

    for edge in outgoingEdges(for: symbol) {
      guard let targetSymbol = lookupSymbol(mangledName: edge.targetMangledName) else { continue }
      let edgeLine =  "• \(edge.kind) \(targetSymbol.displayName)"
      stream <<< edgeLine <<< "\n"
      separatorLength = edgeLine.count
    }

    stream <<< String(repeating: "=", count: separatorLength) <<< "\n"

    for line in symbol.docComment.lines {
      stream <<< line <<< "\n"
    }

    stream.flush()
  }
}
