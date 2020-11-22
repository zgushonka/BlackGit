import XCTest
@testable import BlackGit

class RepositoryCellTests: XCTestCase {
    var sut: RepositoryCell!
    var repository: Repository!

    override func setUpWithError() throws {
        let vc = GitSearchViewController.make(with: GitSearchViewModelMock())
        let _ = vc.view

        repository = .mock
        let cell = vc.tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseIdentifier)
        sut = cell as? RepositoryCell
    }

    func testOutlets() throws {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.detailsLabel)
        XCTAssertNotNil(sut.iconImageView)
        XCTAssertNotNil(sut.iconImageView.image)
    }

    func testSetup() {
        sut.setup(with: repository)
        XCTAssertEqual(sut.id, repository.id)
        XCTAssertEqual(sut.titleLabel.text, repository.name)
        XCTAssertEqual(sut.detailsLabel.text, repository.details)
    }

    func testSetImage() {
        sut.iconImageView.image = nil
        XCTAssertNil(sut.iconImageView.image)
        sut.set(UIImage())
        XCTAssertNotNil(sut.iconImageView.image)
    }
}
