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
    func profileNavigationViewController() -> UINavigationController
    func profileViewController() -> ProfileViewController
    func themeViewController() -> ThemesViewController
    func avatarViewController() -> AvatarViewController
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
        navigationVC.setViewControllers([conversationListViewController()], animated: false)
        return navigationVC
    }
    func conversationListViewController() -> ConversationsListViewController {
        let emitterAnimation = EmitterAnimation()
        let conversationListModel = ConversationListModel(firebaseDataManager: serviceAssembly.firebaseManager,
                                                          coreDataManager: serviceAssembly.coreDataManager)
        let storyboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        let conversationListViewController = storyboard.instantiateViewController(withIdentifier: "ConversationListViewController") as? ConversationsListViewController
        guard let conversationListVC = conversationListViewController else { return ConversationsListViewController() }
        conversationListVC.conversationListModel = conversationListModel
        conversationListVC.presentationAssembly = self
        conversationListVC.emitterAnimation = emitterAnimation
        return conversationListVC
    }
    
    func conversationViewController() -> ConversationViewController {
        let emitterAnimation = EmitterAnimation()
        let storyboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        let conversationsViewController = storyboard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
        guard let conversationsVC = conversationsViewController else { return ConversationViewController() }
        let conversationsModel = ConversationsModel(coreDataManager: serviceAssembly.coreDataManager, firebaseDataManager: serviceAssembly.firebaseManager)
        conversationsVC.conversationsModel = conversationsModel
        conversationsModel.delegate = conversationsVC
        conversationsVC.emitterAnimation = emitterAnimation
        return conversationsVC

    }
    
    func profileNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        let profileNavigationViewController = storyboard.instantiateViewController(withIdentifier: Key.NavigationProfileView.navigationProfileView) as? UINavigationController
        guard let profileNavigationVC = profileNavigationViewController else { return UINavigationController() }
        profileNavigationVC.setViewControllers([profileViewController()], animated: true)
        return profileNavigationVC
    }

    func profileViewController() -> ProfileViewController {
        let emitterAnimation = EmitterAnimation()
        let model = AvatarModel(networkManager: serviceAssembly.networkManager)
        let storyboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        guard let profileVC = profileViewController else { return ProfileViewController() }
        let profileGCDModel = ProfileModel(dataManager: serviceAssembly.gcdDataManager)
        let profileOperationModel = ProfileModel(dataManager: serviceAssembly.operationDataManager)
        profileVC.profileGCDModel = profileGCDModel
        profileVC.profileOperationModel = profileOperationModel
        profileVC.presentationAssembly = self
        profileVC.model = model
        profileVC.emitterAnimation = emitterAnimation
        return profileVC
    }

    func themeViewController() -> ThemesViewController {
        let emitterAnimation = EmitterAnimation()
        let themesStoryboard: UIStoryboard = UIStoryboard(name: Key.ThemesViewController.themeStoryBoard, bundle: nil)
        guard let themesViewController = themesStoryboard.instantiateViewController(withIdentifier: Key.ThemesViewController.themesVCId) as? ThemesViewController
            else { return ThemesViewController() }
        themesViewController.emitterAnimation = emitterAnimation
        return themesViewController
    }
    
    func avatarViewController() -> AvatarViewController {
        let model = AvatarModel(networkManager: serviceAssembly.networkManager)
        let avatarStoryBoard: UIStoryboard = UIStoryboard(name: "Avatar", bundle: nil)
        guard let avatarViewController = avatarStoryBoard.instantiateViewController(withIdentifier: "AvatarViewController") as? AvatarViewController
            else { return AvatarViewController() }
        avatarViewController.model = model
        model.delegate = avatarViewController
        avatarViewController.presentationAssembly = self
        return avatarViewController
    }
}
