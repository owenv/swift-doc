import TSCBasic

extension SymbolGraph {
  public func print(_ symbol: Symbol, to stream: OutputByteStream) {
    let header = "[\(symbol.kind)] \(symbol.displayName)"
    stream <<< header <<< "\n"
    stream <<< symbol.declarationString <<< "\n"
    var separatorLength = symbol.declarationString.count

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
    if symbol.docComment.lines.isEmpty {
      stream <<< "No documentation available.\n"
    }

    let memberEdges = incomingEdges(for: symbol, kind: .memberOf)
    if !memberEdges.isEmpty {
      stream <<< "\nMembers\n"
      stream <<< "=======\n"
      for memberEdge in memberEdges {
        guard let member = lookupSymbol(mangledName: memberEdge.sourceMangledName) else { continue }
        print(member, to: stream)
        stream <<< "\n"
      }
    }
    
    stream.flush()
  }
}
