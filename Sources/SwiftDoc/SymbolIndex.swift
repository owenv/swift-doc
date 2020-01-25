
// FIXME: Turn this into an actual index...
public struct SymbolIndex {

  private var symbolGraphs: [SymbolGraph]

  public init() {
    symbolGraphs = []
  }

  public mutating func index(symbolGraph: SymbolGraph) {
    symbolGraphs += [symbolGraph]
  }

  public func lookupSymbol(_ string: String) -> [(SymbolGraph, SymbolGraph.Symbol)] {

    return symbolGraphs.map {graph in
      graph.symbols.filter() {
        return $0.displayName.hasSuffix(string)
      }.map { (graph, $0) }
    }.reduce([], +)
  }
}
