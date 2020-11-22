import Foundation
import UIKit

protocol ImageService {
    func image(for url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageServiceImpl: ImageService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Fetches images without error handling.
    func image(
        for url: URL,
        completion: @escaping (UIImage?) -> Void
    ) {
        image(for: url) { (result: Result<UIImage, Error>) in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }

    private func image(
        for url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.httpMethod = "get"
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            let image = data.flatMap { UIImage(data: $0) }
            guard let anImage = image else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(anImage))
        }.resume()
    }
}
