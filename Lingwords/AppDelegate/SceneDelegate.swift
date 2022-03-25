//
//  SceneDelegate.swift
//  Lingwords
//
//  Created by Daniil Kostitsin on 07.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let storageService = StorageService()
        DIContainer.shared.register(type: StorageServiceProtocol.self, component: storageService)
//        let rootFolderUUID = storageService.rootFolder.uuid
//        let folder = Folder(name: "Folder 1", items: [])
//        let wordSet = WordSet(name: "WordSet", words: [], isCaseSensitive: true)
//        storageService.addFolder(folder, toFolderWithUUID: rootFolderUUID)
//        storageService.addWordSet(wordSet, toFolderWithUUID: rootFolderUUID)
//        let subfolder = Folder(name: "Subfolder", items: [])
//        storageService.addFolder(subfolder, toFolderWithUUID: folder.uuid)
//        let subfolderWordSet = WordSet(name: "Subfolder word set", words: [], isCaseSensitive: true)
//        storageService.addWordSet(subfolderWordSet, toFolderWithUUID: subfolder.uuid)

        let factory = FolderScreenFactory(folderUUID: storageService.rootFolder.uuid)
        let navigationController = UINavigationController(rootViewController: factory.build())

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
