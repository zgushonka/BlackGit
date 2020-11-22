import UIKit

final class RepositoryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    private (set) var id: Int? = nil

    func setup(with repository: Repository) {
        titleLabel.text = repository.name
        detailsLabel.text = repository.details
        id = repository.id
    }

    func set(_ image: UIImage?) {
        iconImageView.image = image
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        detailsLabel.text = nil
        iconImageView.image = UIImage(named: "placeholder")
        id = nil
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
