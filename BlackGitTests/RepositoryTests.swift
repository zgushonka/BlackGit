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

    func testDecodable() throws {
        sut = try JSONDecoder().decode(Repository.self, from: Repository.jsonData)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.id, 4242)
        XCTAssertEqual(sut.name, "json name")
        XCTAssertEqual(sut.details, "json details")
        XCTAssertNotNil(sut.ownerImageURL)
        XCTAssertEqual(sut.ownerImageURL?.absoluteString, "www.avatar_url.com")
    }
}

extension Repository {
    static var mock: Repository {
        .init(id: 42, name: "mock name", details: "mock details", ownerImageURL: nil)
    }

    static var jsonString: String {
        """
        {
          "id" : 4242,
          "name" : "json name",
          "description" : "json details",

          "owner" : {
            "avatar_url" : "www.avatar_url.com",
          }
        }
        """
    }

    static var jsonData: Data {
        Data(jsonString.utf8)
    }
}

extension Repository: Equatable {
    public static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
}
