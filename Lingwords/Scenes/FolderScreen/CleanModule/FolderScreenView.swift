//
//  FolderScreenView.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import UIKit

/// FolderScreen view
protocol FolderScreenViewProtocol: AnyObject {

    var interactor: FolderScreenInteractorProtocol? { get set }
    var router: FolderScreenRouterProtocol? { get set }

    /// Displays specified folder and its items
    /// - Parameter folder: folder view model
    func show(folder: FolderViewModel)
}

final class FolderScreenView: UITableViewController {

    // MARK: Constants

    private enum Constant {
        static let numberOfSections = 2
    }

    private enum Section: Int {
        case folder = 0
        case wordSet = 1

        var sectionName: String {
            switch self {
            case .folder:
                return "Folders"
            case .wordSet:
                return "Word Sets"
            }
        }
    }

    private enum CellIdentifier {
        static let folder = "FolderCell"
        static let wordSet = "WordSetCell"
    }

    // MARK: Properties

    var interactor: FolderScreenInteractorProtocol?
    var router: FolderScreenRouterProtocol?

    private var folderUUID: UUID?
    private var folders: [FolderViewModel.Item] = []
    private var wordSets: [FolderViewModel.Item] = []

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.folder)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.wordSet)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        interactor?.requestFolder()
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        Constant.numberOfSections
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.sectionName
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
        case .folder:
            return folders.count
        case .wordSet:
            return wordSets.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        let cell: UITableViewCell
        let viewModel: FolderViewModel.Item
        switch section {
        case .folder:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.folder, for: indexPath)
            viewModel = folders[indexPath.row]
        case .wordSet:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.wordSet, for: indexPath)
            viewModel = wordSets[indexPath.row]
        }

        var content = cell.defaultContentConfiguration()
        content.text = viewModel.name
        content.image = viewModel.icon

        cell.contentConfiguration = content

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }

        switch section {
        case .folder:
            let viewModel = folders[indexPath.row]
            router?.routeToSubfolder(withUUID: viewModel.uuid)
        case .wordSet:
            let viewModel = wordSets[indexPath.row]
            router?.routeToWordSet(withUUID: viewModel.uuid)
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
        case .folder:
            let viewModel = folders[indexPath.row]
            interactor?.removeItem(withUUID: viewModel.uuid)
        case .wordSet:
            let viewModel = wordSets[indexPath.row]
            interactor?.removeItem(withUUID: viewModel.uuid)
        }
    }
}

// MARK: - FolderScreenViewProtocol

extension FolderScreenView: FolderScreenViewProtocol {

    func show(folder: FolderViewModel) {
        folderUUID = folder.uuid
        wordSets.removeAll()
        folders.removeAll()
        for item in folder.items {
            switch item {
            case .wordSet:
                wordSets.append(item)
            case .folder:
                folders.append(item)
            }
        }
        navigationItem.title = folder.name
        tableView.reloadData()
    }
}
