import XCTest
@testable import BlackGit

class GitSearchViewControllerTests: XCTestCase {
    var sut: GitSearchViewController!
    var viewModelMock: GitSearchViewModelMock!

    override func setUpWithError() throws {
        viewModelMock = GitSearchViewModelMock()
        sut = .make(with: viewModelMock)

        let _ = sut.view
    }

    func testOutlets() throws {
        XCTAssertNotNil(sut.tableView)
    }

    func testSearchBar() throws {
        let searchString = "new query"
        sut.searchBar(UISearchBar(), textDidChange: searchString)

        XCTAssert(viewModelMock.searchInvoded)
        XCTAssertEqual(viewModelMock.searhedString, searchString)
    }
}
