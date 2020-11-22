import UIKit

extension GitSearchViewController {
    class func make(
        with viewModel: GitSearchViewModel
    ) -> GitSearchViewController {
        let viewController = GitSearchViewController.from(storyboard: .main)
        viewController.viewModel = viewModel
        return viewController
    }
}

final class GitSearchViewController: UITableViewController {
    private var viewModel: GitSearchViewModel?
    private lazy var searchBar:UISearchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel?.screenTitle

        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        setupSearchBar()
        searchBar.becomeFirstResponder()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.repositoriesCount ?? 0
    }

    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseIdentifier, for: indexPath)

        if let cell = cell as? RepositoryCell,
           let repository = viewModel?.repository(for: indexPath.row) {
            cell.setup(with: repository)
            updateImage(cell, repository: repository)
        }
        return cell
    }

    private func updateImage(_ cell: RepositoryCell, repository: Repository) {
        guard let url = repository.ownerImageURL else { return }

        viewModel?.imageService.image(for: url, completion: { image in
            guard cell.id == repository.id else  { return }

            DispatchQueue.main.async {
                cell.set(image)
            }
        })
    }
}

extension GitSearchViewController: UISearchBarDelegate {
    private func setupSearchBar() {
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search Git by Name"
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        tableView.tableHeaderView = searchBar
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrint("searchBar - \(searchText.isEmpty ? "cancel" : searchText)")
        viewModel?.search(by: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
