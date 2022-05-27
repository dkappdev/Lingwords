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

        let persistenceService = PersistenceService()
        DIContainer.shared.register(type: PersistenceServiceProtocol.self, component: persistenceService)
        let storageService = StorageService()
        DIContainer.shared.register(type: StorageServiceProtocol.self, component: storageService)

//        let rootFolderUUID = storageService.rootFolderUUID
//        let folder = Folder(name: "Folder 1")
//        let wordSet = WordSet(name: "WordSet", isCaseSensitive: true)
//        storageService.addFolder(folder, toFolderWithUUID: rootFolderUUID)
//        storageService.addWordSet(wordSet, toFolderWithUUID: rootFolderUUID)
//        let subfolder = Folder(name: "Subfolder")
//        storageService.addFolder(subfolder, toFolderWithUUID: folder.uuid)
//        let subfolderWordSet = WordSet(name: "Subfolder word set", isCaseSensitive: true)
//        storageService.addWordSet(subfolderWordSet, toFolderWithUUID: subfolder.uuid)

        guard let factory = FolderScreenFactory(folderUUID: storageService.rootFolderUUID) else { return }
        let navigationController = UINavigationController(rootViewController: factory.build())

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
