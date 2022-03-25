//
//  FolderScreenView.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 08.03.2022.
//

import UIKit

/// FolderScreen view
public protocol FolderScreenViewProtocol: AnyObject {

    var interactor: FolderScreenInteractorProtocol? { get set }
    var router: FolderScreenRouterProtocol? { get set }

    /// Displays specified folder and its items
    /// - Parameter folder: folder view model
    func show(folder: FolderViewModel)
}

public final class FolderScreenView: UITableViewController {

    // MARK: Constants

    private enum Section {
        case folder
        case wordSet
    }

    private enum CellIdentifier: String {
        case folder = "FolderCell"
        case wordSet = "WordSetCell"
    }

    // MARK: Properties

    public var interactor: FolderScreenInteractorProtocol?
    public var router: FolderScreenRouterProtocol?

    private var folders: [ItemViewModel] = []
    private var wordSets: [ItemViewModel] = []

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.folder.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.wordSet.rawValue)
    }

    public override func viewWillAppear(_ animated: Bool) {
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

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return (folders.isEmpty ? 0 : 1) + (wordSets.isEmpty ? 0 : 1)
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = getSection(for: section) else { return nil }

        switch section {
        case .folder:
            return "Folders"
        case .wordSet:
            return "Word Sets"
        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = getSection(for: section) else { return 0 }

        switch section {
        case .folder:
            return folders.count
        case .wordSet:
            return wordSets.count
        }
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = getSection(for: indexPath.section) else { return UITableViewCell() }

        let cell: UITableViewCell
        let viewModel: ItemViewModel

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

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    public override func tableView(_ tableView: UITableView,
                                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    public override func tableView(_ tableView: UITableView,
                                   commit editingStyle: UITableViewCell.EditingStyle,
                                   forRowAt indexPath: IndexPath) {
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

    public func show(folder: FolderViewModel) {
        folders = folder.items.filter { $0.type == .folder }
        wordSets = folder.items.filter { $0.type == .wordSet }
        navigationItem.title = folder.name
        tableView.reloadData()
    }
}
