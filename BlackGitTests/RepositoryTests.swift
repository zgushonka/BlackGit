import XCTest
@testable import BlackGit

class RepositoryTests: XCTestCase {
    var sut: Repository!

    func testInitValues() throws {
        sut = .init(
            id: 42,
            name: "testName",
            details: "test details",
            ownerImageURL: URL(string: "www.test.com")
        )

        XCTAssertEqual(sut.id, 42)
        XCTAssertEqual(sut.name, "testName")
        XCTAssertEqual(sut.details, "test details")
        XCTAssertNotNil(sut.ownerImageURL)
        XCTAssertEqual(sut.ownerImageURL?.absoluteString, "www.test.com")
    }

    func testOtherInitValues() throws {
        sut = .init(
            id: 24,
            name: "Name test",
            details: nil,
            ownerImageURL: nil
        )

        XCTAssertEqual(sut.id, 24)
        XCTAssertEqual(sut.name, "Name test")
        XCTAssertNil(sut.details)
        XCTAssertNil(sut.ownerImageURL)
    }
}

extension Repository {
    static var mock: Repository {
        .init(id: 42, name: "mock name", details: "mock details", ownerImageURL: nil)
    }
}

extension Repository: Equatable {
    public static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
}
