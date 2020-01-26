import XCTest
import SwiftDoc

final class SymbolGraphTests: XCTestCase {

  func loadSymbolGraph() throws -> SymbolGraph {
    let decoder = JSONDecoder()
    return try decoder.decode(SymbolGraph.self, from: testSymbolGraphData)
  }

  func testDeserialization() {
    XCTAssertNoThrow(try loadSymbolGraph())
  }

  func testSymbols() throws {
    let graph = try loadSymbolGraph()
    let sym = graph.lookupSymbol(mangledName: "s:s7UnicodeO5UTF16O7isASCIIySbs6UInt16VFZ")
    XCTAssertNotNil(sym)
    XCTAssertEqual(sym?.displayName, "Unicode.UTF16.isASCII(_:)")
    XCTAssertEqual(sym?.kind, .function)
    XCTAssertEqual(sym?.docComment.lines, ["Returns whether the given code unit represents an ASCII scalar"])
  }

  func testEdges() throws {
    let graph = try loadSymbolGraph()
    let sym = graph.lookupSymbol(mangledName: "s:s7UnicodeO5UTF16O7isASCIIySbs6UInt16VFZ")
    XCTAssertNotNil(sym)
    let edges = graph.outgoingEdges(for: sym!)
    XCTAssertEqual(edges.count, 2)
    XCTAssertTrue(edges.contains(where: {
      $0.targetMangledName == "s:SS9UTF16ViewV" && $0.kind == .conformsTo
    }))
    XCTAssertTrue(edges.contains(where: {
      $0.targetMangledName == "s:Ss9UTF16ViewV" && $0.kind == .memberOf
    }))

  }
}
