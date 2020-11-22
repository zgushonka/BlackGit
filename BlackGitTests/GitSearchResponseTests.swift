import XCTest
@testable import BlackGit

class GitSearchResponseTests: XCTestCase {
    var sut: GitSearchResponse!

    func testInitValues() throws {
        sut = .init(totalCount: 42, items: [])

        XCTAssertEqual(sut.totalCount, 42)
        XCTAssert(sut.items.isEmpty)
    }

    func testOtherInitValues() throws {
        sut = .init(totalCount: 24, items: [.mock])

        XCTAssertEqual(sut.totalCount, 24)
        XCTAssertEqual(sut.items.count, 1)

        XCTAssertNotNil(sut.items.first)
        XCTAssertEqual(sut.items.first?.id, Repository.mock.id)
        XCTAssertEqual(sut.items.first?.name, Repository.mock.name)
        XCTAssertEqual(sut.items.first?.details, Repository.mock.details)
        XCTAssertNil(sut.items.first?.ownerImageURL)
    }
}
