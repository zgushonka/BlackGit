import XCTest
@testable import BlackGit

class GitSearchViewModelTests: XCTestCase {
    var sut: GitSearchViewModelImpl!
    var imageServiceMock: ImageServiceMock!
    var gitSearchServiceMock: GitSearchServiceMock!

    override func setUpWithError() throws {
        imageServiceMock = ImageServiceMock()
        gitSearchServiceMock = GitSearchServiceMock()

        XCTAssertNotNil(imageServiceMock)
        XCTAssertNotNil(gitSearchServiceMock)

        sut = .init(
            imageService: imageServiceMock,
            gitSearchService: gitSearchServiceMock
        )
    }

    func testMocks() throws {
        XCTAssertNotNil(imageServiceMock)
        XCTAssertEqual(imageServiceMock.invocationCount, 0)

        XCTAssertNotNil(gitSearchServiceMock)
        XCTAssertEqual(gitSearchServiceMock.invocationCount, 0)
    }

    func testHasTitle() throws {
        XCTAssertEqual(sut.screenTitle, "Repositories")
    }

    func testHasOnUpdate() throws {
        let exp = XCTestExpectation(description: "onUpdate")
        sut.onUpdate = {
            exp.fulfill()
        }
        sut.onUpdate?()
        wait(for: [exp], timeout: 1)
    }

    func testHasImageService() throws {
        XCTAssertNotNil(sut.imageService)
    }

    func testRepositoriesCountZero() throws {
        XCTAssertEqual(sut.repositoriesCount, 0)
    }

    func testRepositoriesCountAfterFetch() throws {
        XCTAssertEqual(sut.repositoriesCount, 0)

        sut.search(by: "test")

        XCTAssertEqual(sut.repositoriesCount, 1)
        XCTAssertEqual(sut.repository(for: 0), .mock)
    }

    func testRepositoriesCountZeroAfterCancel() throws {
        XCTAssertEqual(sut.repositoriesCount, 0)
        sut.search(by: "test")
        XCTAssertEqual(sut.repositoriesCount, 1)
        sut.search(by: "")
        XCTAssertEqual(sut.repositoriesCount, 0)
    }
}

class GitSearchViewModelMock: GitSearchViewModel {
    var screenTitle: String = "screenTitle"

    var repositoriesCount: Int = 1

    func repository(for index: Int) -> Repository? {
        return .mock
    }

    var searchInvoded = false
    var searhedString: String? = nil
    func search(by query: String) {
        searchInvoded = true
        searhedString = query
    }

    var onUpdate: (() -> Void)? = nil

    var imageService: ImageService = ImageServiceMock()
}
