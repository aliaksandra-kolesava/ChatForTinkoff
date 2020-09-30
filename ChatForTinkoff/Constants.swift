//
//  Constants.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

struct K {
    
    class ConversationList {
    static let cellIdentifier = "ConversationCellList"
    static let cellNibName = "ConversationCell"
    static let toConversationTapped = "conversationIsTapped"
    }
    
    class Conversation {
        static let cellIdentifier = "ReusableCell"
        static let cellNibName = "MessageCell"
        static let conversationViewControllerId = "ConversationViewController"
    }
    
    class StoryBoardName {
        static let mainStoryBoard = "Main"
    }
    
    class NavigationProfileView {
        static let navigationProfileView = "NavigationControllerProfile"
    }
}
