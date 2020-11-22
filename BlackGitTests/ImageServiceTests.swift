import XCTest
@testable import BlackGit

class ImageServiceTests: XCTestCase {
    var sut: ImageServiceImpl!
    var url: URL!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)

        url = URL(string: "www.test.com")!
        expectation = expectation(description: "make request")

        sut = .init(session: urlSession)
    }

    func testSearchRequest() throws {
        let data = imageData
        XCTAssertNotNil(data)
        setRequestHandler(with: data)
        sut.image(for: url, completion: { image in
            if image != nil {
                self.expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: 1)
    }

    func testSearchRequestFail() throws {
        setRequestHandler(with: Data())
        sut.image(for: url, completion: { image in
            if image == nil {
                self.expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: 1)
    }
}

extension ImageServiceTests {
    var imageData: Data? {
        UIImage(named: "placeholder")?.pngData()
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

class ImageServiceMock: ImageService {
    var invocationCount: Int = 0

    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        invocationCount += 1
        completion(nil)
    }
}
