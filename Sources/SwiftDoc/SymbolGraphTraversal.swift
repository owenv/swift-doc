//
//  SymbolGraphTraversal.swift
//  
//
//  Created by Owen Voorhees on 8/30/20.
//

extension SymbolGraph {
  public func lookupSymbol(usr: String) -> Symbol? {
    return symbols.filter { $0.identifier.usr == usr }.first
  }

  public func outgoingEdges(for symbol: Symbol, kind: Edge.Kind? = nil) -> [Edge] {
    return relationships.filter {
      guard $0.source == symbol.identifier.usr else { return false }
      if let kind = kind {
        guard $0.kind == kind else { return false }
      }
      return true
    }
  }

  public func incomingEdges(for symbol: Symbol, kind: Edge.Kind? = nil) -> [Edge] {
    return relationships.filter {
      guard $0.target == symbol.identifier.usr else { return false }
      if let kind = kind {
        guard $0.kind == kind else { return false }
      }
      return true
    }
  }
}
