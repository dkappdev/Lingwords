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

    private enum Section {
        case folder
        case wordSet

        var sectionName: String {
            switch self {
            case .folder:
                return "Folders"
            case .wordSet:
                return "Word Sets"
            }
        }
    }

    private enum CellIdentifier: String {
        case folder = "FolderCell"
        case wordSet = "WordSetCell"
    }

    // MARK: Properties

    var interactor: FolderScreenInteractorProtocol?
    var router: FolderScreenRouterProtocol?

    private var folders: [FolderItemViewModel] = []
    private var wordSets: [FolderItemViewModel] = []

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.folder.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.wordSet.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        interactor?.requestFolder()
    }

    // MARK: Private

    private func getSection(for index: Int) -> Section? {
        if index == 1 && !folders.isEmpty, !wordSets.isEmpty { return .wordSet }

        if folders.isEmpty && wordSets.isEmpty { return nil }

        guard index == 0 else { return nil }

        if !folders.isEmpty { return .folder }

        if !wordSets.isEmpty { return .wordSet }

        return nil
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (folders.isEmpty ? 0 : 1) + (wordSets.isEmpty ? 0 : 1)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        getSection(for: section)?.sectionName
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = getSection(for: section) else { return 0 }

        switch section {
        case .folder:
            return folders.count
        case .wordSet:
            return wordSets.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = getSection(for: indexPath.section) else { return UITableViewCell() }

        let cell: UITableViewCell
        let viewModel: FolderItemViewModel
        switch section {
        case .folder:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.folder.rawValue, for: indexPath)
            viewModel = folders[indexPath.row]
        case .wordSet:
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.wordSet.rawValue, for: indexPath)
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
        guard let section = getSection(for: indexPath.section) else { return }

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
        guard let section = getSection(for: indexPath.section) else { return }

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
