//
//  Constants.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

struct Key {
    
    class ConversationList {
    static let cellIdentifier = "ConversationCellList"
    static let cellNibName = "ConversationCell"
    static let toConversationTapped = "conversationIsTapped"
    }
    
    class Conversation {
        static let cellIdentifier = "ReusableCell"
        static let cellNibName = "MessageCell"
        static let conversationVCId = "ConversationViewController"
    }
    
    class StoryBoardName {
        static let mainStoryBoard = "Main"
    }
    
    class NavigationProfileView {
        static let navigationProfileView = "NavigationControllerProfile"
    }
    
    class ThemesViewController {
        static let themeStoryBoard = "Themes"
        static let themesVCId = "ThemesViewController"
    }
    
    class ProfileInfoKeys {
        static let nameData = "nameData"
        static let aboutYourselfData = "aboutYourselfData"
        static let imageData = "imageData"
    }
    
    class FStore {
        static let channels = "channels"
        
        static let identifier = "identifier"
        static let name = "name"
        static let lastMessage = "lastMessage"
        static let lastActivity = "lastActivity"
        
        static let content = "content"
        static let created = "created"
        static let senderId = "senderId"
        static let senderName = "senderName"
    }
    
    class Avatar {
        static let reuseCell = "AvatarCell"
    }
}
