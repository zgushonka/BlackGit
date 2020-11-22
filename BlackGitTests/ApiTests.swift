import XCTest
@testable import BlackGit

class ApiTests: XCTestCase {
    var searchUrl: URL!

    override func setUpWithError() throws {
        searchUrl = API.Search.repositories("testQuery").makeURL()
    }

    func testUrlString() throws {
        XCTAssertEqual(
            searchUrl.absoluteString,
            "https://api.github.com/search/repositories?q=testQuery"
        )
    }
}
