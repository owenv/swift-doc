import XCTest
import SwiftDoc

final class SymbolGraphTests: XCTestCase {

  func loadSymbolGraph() throws -> SymbolGraph {
    let path = Bundle.module.path(forResource: "NIOConcurrencyHelpers.symbols", ofType: "json")!
    let decoder = JSONDecoder()
    return try decoder.decode(SymbolGraph.self, from: Data(contentsOf: URL(fileURLWithPath: path)))
  }

  func testDeserialization() {
    XCTAssertNoThrow(try loadSymbolGraph())
  }

  func testSymbols() throws {
    let graph = try loadSymbolGraph()
    let sym = graph.lookupSymbol(usr: "s:21NIOConcurrencyHelpers9NIOAtomicC")
    XCTAssertNotNil(sym)
    XCTAssertEqual(sym?.names.title, "NIOAtomic")
    XCTAssertEqual(sym?.kind, .class)
    XCTAssertEqual(sym?.docComment?.lines.map(\.text), ["An encapsulation of an atomic primitive object.",
                                                        "",
                                                        "Atomic objects support a wide range of atomic operations:",
                                                        "",
                                                        "- Compare and swap",
                                                        "- Add",
                                                        "- Subtract",
                                                        "- Exchange",
                                                        "- Load current value",
                                                        "- Store current value",
                                                        "",
                                                        "Atomic primitives are useful when building constructs that need to",
                                                        "communicate or cooperate across multiple threads. In the case of",
                                                        "SwiftNIO this usually involves communicating across multiple event loops.",
                                                        "",
                                                        "By necessity, all atomic values are references: after all, it makes no",
                                                        "sense to talk about managing an atomic value when each time it\'s modified",
                                                        "the thread that modified it gets a local copy!"])
  }

  func testEdges() throws {
    let graph = try loadSymbolGraph()
    let sym = graph.lookupSymbol(usr: "s:21NIOConcurrencyHelpers9NIOAtomicC")
    XCTAssertNotNil(sym)
    let edges = graph.incomingEdges(for: sym!)
    XCTAssertEqual(edges.count, 7)
    XCTAssertTrue(edges.contains(where: {
      $0.source == "s:21NIOConcurrencyHelpers9NIOAtomicC10makeAtomic5valueACyxGx_tFZ" &&
        $0.target == "s:21NIOConcurrencyHelpers9NIOAtomicC" &&
        $0.kind == .memberOf
    }))
  }
}
