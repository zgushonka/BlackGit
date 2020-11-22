import XCTest
@testable import BlackGit

class GitSearchServiceTests: XCTestCase {
    var sut: GitSearchServiceImpl!
    var url: URL!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)

        url = URL(string: "https://api.github.com/search/repositories?q=testSearch")!
        expectation = expectation(description: "make request")

        sut = .init(session: urlSession)
    }

    func testSearchRequest() throws {
        setRequestHandler(with: jsonData)
        sut.searchRepositories(with: "testSearch", completion: { result in
            switch result {
            case .success(_):
                self.expectation.fulfill()
            case .failure(_):
                XCTFail("Error: should not fail")
            }
        })

        wait(for: [expectation], timeout: 1)
    }

    func testSearchRequestFail() throws {
        setRequestHandler(with: Data())
        sut.searchRepositories(with: "testSearch", completion: { result in
            switch result {
            case .success(_):
                XCTFail("Error: should not succeed")
            case .failure(_):
                self.expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: 1)
    }
}

extension GitSearchServiceTests {
    var jsonData: Data? {
        let totalCount = 5
        let jsonString = """
                             {
                                "total_count": \(totalCount),
                             }
                         """
        let data = jsonString.data(using: .utf8)
        return data
    }

    func setRequestHandler(with data: Data?) {
        MockURLProtocol.requestHandler = { request in
            guard let requestUrl = request.url,
                  requestUrl == self.url
            else {
                throw NetworkError.wrongRequest
            }

            let response = HTTPURLResponse(
                url: self.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, data)
        }
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
