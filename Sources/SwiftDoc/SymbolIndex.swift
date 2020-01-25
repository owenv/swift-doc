
// FIXME: This is terrible. It needs much better lookup and should support
// disambiguating symbols by module, typo correction, etc.
public struct SymbolIndex {

  private var symbols: [SymbolGraph.Symbol]

  public init() {
    symbols = []
  }

  public mutating func index(symbolGraph: SymbolGraph) {
    symbols += symbolGraph.symbols
  }

  public func lookupSymbol(_ string: String) -> [SymbolGraph.Symbol] {
    return symbols.filter() {
      return $0.identifier.displayNameComponents.joined(separator: ".").hasSuffix(string)
    }
  }
}
