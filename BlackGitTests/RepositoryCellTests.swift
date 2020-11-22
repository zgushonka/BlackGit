import XCTest
@testable import BlackGit

class RepositoryCellTests: XCTestCase {
    var sut: RepositoryCell!

    override func setUpWithError() throws {
        let vc = GitSearchViewController.make(with: GitSearchViewModelMock())
        let _ = vc.view

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
        sut.setup(with: .mock)
        XCTAssertEqual(sut.titleLabel.text, "mock name")
        XCTAssertEqual(sut.detailsLabel.text, "mock details")
    }

    func testSetImage() {
        sut.iconImageView.image = nil
        XCTAssertNil(sut.iconImageView.image)
        sut.set(UIImage())
        XCTAssertNotNil(sut.iconImageView.image)
    }
}
