import Foundation

protocol GitSearchViewModel: HasTitle, HasRepositories, GitRepositorySearchable, HasUpdate, HasImageService {}

final class GitSearchViewModelImpl: GitSearchViewModel {
    let screenTitle = "Repositories"
    var onUpdate: (() -> Void)? = nil        
    let imageService: ImageService

    private let gitSearchService: GitSearchService

    private var repositories: [Repository] = [] {
        didSet { onUpdate?() }
    }

    init(
        imageService: ImageService,
        gitSearchService: GitSearchService
    ) {
        self.imageService = imageService
        self.gitSearchService = gitSearchService
    }
}

extension GitSearchViewModelImpl {
    var repositoriesCount: Int { repositories.count }

    func repository(for index: Int) -> Repository? {
        guard repositories.indices.contains(index) else { return nil }

        return repositories[index]
    }
}

extension GitSearchViewModelImpl {
    func search(by query: String) {
        if query.isEmpty {
            repositories = []
        }
        gitSearchService.searchRepositories(with: query) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
