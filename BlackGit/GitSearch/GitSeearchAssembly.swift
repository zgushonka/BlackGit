import Foundation

enum GitSearchAssembly {
    static func makeVC() -> GitSearchViewController {
        let imageService = ImageServiceImpl()
        let gitSearchService = GitSearchServiceImpl(
            throttler: Throttler(timeInterval: 1)
        )

        let viewModel = GitSearchViewModelImpl(
            imageService: imageService,
            gitSearchService: gitSearchService
        )
        
        let viewController = GitSearchViewController.make(with: viewModel)
        return viewController
    }
}
