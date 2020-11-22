import UIKit

enum Storyboard: String {
    case main = "Main"
}

private extension Storyboard {
    func instantiateViewController<T>(with id: String) -> T {
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: id) as? T else {
            fatalError("Error: View controller: \(id) from storyboard: \(rawValue) is not found.")
        }
        return viewController
    }
}

extension UIViewController {
    static func from(storyboard: Storyboard) -> Self {
        storyboard.instantiateViewController(with: String(describing: self))
    }
}
