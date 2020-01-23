import XCTest
@testable import SwiftDoc

final class SwiftDocTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftDoc().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
