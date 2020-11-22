import XCTest
@testable import BlackGit

class GitSearchAssemblyTests: XCTestCase {
    var vc: UIViewController!

    override func setUpWithError() throws {
        vc = GitSearchAssembly.makeVC()
    }

    func testCreatesVc() throws {
        XCTAssertNotNil(vc)
    }
}
