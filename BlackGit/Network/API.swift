import Foundation

enum API {
    static let baseURL = "https://api.github.com/"
}

extension API {
    enum Search {
        case repositories(String)

        func makeURL() -> URL? {
            switch self {
            case .repositories(let query):
                var urlComps = URLComponents(string: API.baseURL + "search/repositories")
                let queryItems = [URLQueryItem(name: "q", value: query)]
                urlComps?.queryItems = queryItems
                return urlComps?.url
            }
        }
    }
}
