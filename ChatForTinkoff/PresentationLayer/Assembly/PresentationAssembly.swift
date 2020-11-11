//
//  PresentationAssembly.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 10.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

protocol PresentationAssemblyProtocol {
    func mainNavigationViewController() -> UINavigationController
    func conversationListViewController() -> ConversationsListViewController
    func conversationViewController() -> ConversationViewController
//    func profileViewController() -> ProfileViewController
//    func themeViewController() -> ThemesViewController
}

class PresentationAssembly: PresentationAssemblyProtocol {
    
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    func mainNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        let navigationViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController") as? UINavigationController
        guard let navigationVC = navigationViewController else { return UINavigationController() }
        navigationVC.setViewControllers([conversationListViewController()], animated: true)
        return navigationVC
    }
    func conversationListViewController() -> ConversationsListViewController {
        let conversationListModel = ConversationListModel(firebaseDataManager: serviceAssembly.firebaseManager, coreDataManager: serviceAssembly.coreDataManager)
        let storyboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        let conversationListViewController = storyboard.instantiateViewController(withIdentifier: "ConversationListViewController") as? ConversationsListViewController
        guard let conversationListVC = conversationListViewController else { return ConversationsListViewController() }
        conversationListVC.conversationListModel = conversationListModel
        conversationListVC.presentationAssembly = self
        conversationListModel.delegate = conversationListVC
        return conversationListVC
    }
    
    func conversationViewController() -> ConversationViewController {
        let storyboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        let conversationsViewController = storyboard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
        guard let conversationsVC = conversationsViewController else { return ConversationViewController() }
        let conversationsModel = ConversationsModel(coreDataManager: serviceAssembly.coreDataManager, firebaseDataManager: serviceAssembly.firebaseManager)
        conversationsVC.conversationsModel = conversationsModel
        conversationsModel.delegate = conversationsVC
        return conversationsVC

    }
//
//    func profileViewController() -> ProfileViewController {
//        <#code#>
//    }
//
//    func themeViewController() -> ThemesViewController {
//        <#code#>
//    }
    
}
