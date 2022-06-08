//
//  WordSetScreenView.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 04.06.2022.
//

import UIKit

protocol WordSetScreenViewProtocol: AnyObject {

    var interactor: WordSetScreenInteractorProtocol? { get set }
    var router: WordSetScreenRouterProtocol? { get set }

    /// Displays specified word set
    /// - Parameter wordSet: word set view model
    func show(wordSet: WordSetViewModel)
}

final class WordSetScreenView: UITableViewController {

    // MARK: Constants

    private enum Section: Int {
        case words = 0

        var sectionName: String? {
            switch self {
            case .words:
                return "Words"
            }
        }
    }

    private enum Constant {
        static let numberOfSections = 1
    }

    private enum CellIdentifier {
        static let word = "WordCell"
    }

    // MARK: Properties

    var interactor: WordSetScreenInteractorProtocol?
    var router: WordSetScreenRouterProtocol?

    private var wordSetUUID: UUID?

    private var words: [WordSetViewModel.Word] = []

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.word)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        interactor?.requestWordSet()
    }

    // MARK: Private

    private func getSection(for index: Int) -> Section? {
        if index == 0 {
            return .words
        }

        return nil
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        Constant.numberOfSections
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        getSection(for: section)?.sectionName
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = getSection(for: section) else { return 0 }

        switch section {
        case .words:
            return words.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        let cell: UITableViewCell
        let viewModel: WordSetViewModel.Word
        switch section {
        case .words:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.word, for: indexPath)
            viewModel = words[indexPath.row]
        }

        var content = cell.defaultContentConfiguration()
        content.text = "\(viewModel.term) - \(viewModel.definition)"

        cell.contentConfiguration = content

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }

        switch section {
        case .words:
            let viewModel = words[indexPath.row]
            router?.routeToWord(withUUID: viewModel.uuid)
        }
    }

    override func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        .delete
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard let section = Section(rawValue: indexPath.section) else { return }

        switch section {
        case .words:
            let viewModel = words[indexPath.row]
            interactor?.removeWord(withUUID: viewModel.uuid)
        }
    }
}

// MARK: - WordSetScreenViewProtocol

extension WordSetScreenView: WordSetScreenViewProtocol {

    func show(wordSet: WordSetViewModel) {
        wordSetUUID = wordSet.uuid
        words = wordSet.words
        navigationItem.title = wordSet.name
        tableView.reloadData()
    }
}
