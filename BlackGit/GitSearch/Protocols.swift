import Foundation

protocol HasTitle {
    var screenTitle: String { get }
}

protocol GitRepositorySearchable {
    func search(by: String)
}

protocol HasRepositories {
    var repositoriesCount: Int { get }
    func repository(for index: Int) -> Repository?
}

protocol HasUpdate {
    var onUpdate: (() -> Void)? { get set }
}

protocol HasImageService {
    var imageService: ImageService { get }
}
