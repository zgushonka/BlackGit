import Foundation
import UIKit

enum NetworkError: Error {
    case wrongRequest
    case noData
}

protocol GitSearchService {
    func searchRepositories(with query: String, completion: @escaping (Result<[Repository], Error>) -> Void)
}

final class GitSearchServiceImpl: GitSearchService {
    private let session: URLSession
    private let throttler: Throttler?
    private let decoder = JSONDecoder()

    init(
        session: URLSession = .shared,
        throttler: Throttler? = nil
    ) {
        self.session = session
        self.throttler = throttler
    }
    
    func searchRepositories(with query: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let networkRequestBlock = {
            debugPrint("network - \(query)")
            guard let url = API.Search.repositories(query).makeURL() else {
                completion(.failure(NetworkError.wrongRequest))
                return
            }
            self.networkSearch(with: url, completion: completion)
        }
        
        if let throttler = throttler {
            guard !query.isEmpty else {
                throttler.cancel()
                return
            }
            throttler.throttle(block: networkRequestBlock)
        } else {
            networkRequestBlock()
        }
    }
    
    private func networkSearch(with url: URL, completion: @escaping (Result<[Repository], Error>) -> Void) {
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = "get"

        let decoder = self.decoder
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data,
                  let response = try? decoder.decode(GitSearchResponse.self, from: data) else {
                completion(.failure(NetworkError.noData))
                return
            }

            debugPrint("total count - \(response.totalCount)")
            debugPrint("total items - \(response.items.count)")
            completion(.success(response.items))
        }.resume()
    }
}
