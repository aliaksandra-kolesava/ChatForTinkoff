//
//  ConversationsExamples.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 28.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

class ConversationsExamples {
var conversationCellModel: [ConversationCellModel] = [
    // swiftlint:disable line_length
    ConversationCellModel(name: "Ronald Robertson", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: true, hasUnreadMessages: true),
    ConversationCellModel(name: "Johnny Watson", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: true, hasUnreadMessages: true),
    ConversationCellModel(name: "Martha Craig", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(timeIntervalSinceReferenceDate: -123456789.0), isOnline: true, hasUnreadMessages: false),
    ConversationCellModel(name: "Arthur Bell", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: true, hasUnreadMessages: false),
    ConversationCellModel(name: "Jane Warren", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: false, hasUnreadMessages: false),
    ConversationCellModel(name: "Morris Henry", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(timeIntervalSinceReferenceDate: -1234567.0), isOnline: false, hasUnreadMessages: true),
    ConversationCellModel(name: "Irma Flores", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: false, hasUnreadMessages: true),
    ConversationCellModel(name: "Colin Williams", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: false, hasUnreadMessages: true),
    ConversationCellModel(name: "Joseph Flores", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(timeIntervalSinceReferenceDate: -1234789.0), isOnline: false, hasUnreadMessages: true),
    ConversationCellModel(name: "Marta Williams", message: "", date: Date(timeIntervalSince1970: -1.0), isOnline: false, hasUnreadMessages: false),
    ConversationCellModel(name: "Megan Bell", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: true, hasUnreadMessages: false),
    ConversationCellModel(name: "Johanna Warren", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: false, hasUnreadMessages: false),
    ConversationCellModel(name: "Donald Dobertson", message: "", date: Date(timeIntervalSince1970: -1.0), isOnline: true, hasUnreadMessages: false),
       ConversationCellModel(name: "John Catson", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: true, hasUnreadMessages: true),
    ConversationCellModel(name: "Sam Robertson", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(timeIntervalSinceReferenceDate: -1456789.0), isOnline: true, hasUnreadMessages: true),
       ConversationCellModel(name: "Rohn Batson", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: true, hasUnreadMessages: true),
    ConversationCellModel(name: "Melody Tobertson", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(timeIntervalSinceReferenceDate: -13456789.0), isOnline: true, hasUnreadMessages: true),
    ConversationCellModel(name: "Sam Henry", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: false, hasUnreadMessages: true),
    ConversationCellModel(name: "Irma Flores", message: MessagesExample().messages[MessagesExample().messages.count - 1].text, date: Date(), isOnline: false, hasUnreadMessages: true),
    ConversationCellModel(name: "Gerry Henry", message: "", date: Date(timeIntervalSince1970: -1.0), isOnline: false, hasUnreadMessages: false)]
}

class MessagesExample {
    var messages: [MessageCellModel] = [
        MessageCellModel(sender: "1@gmail.com", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    MessageCellModel(sender: "2@gmail.com", text: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
    MessageCellModel(sender: "1@gmail.com", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    MessageCellModel(sender: "2@gmail.com", text: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
    MessageCellModel(sender: "1@gmail.com", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    MessageCellModel(sender: "2@gmail.com", text: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
    MessageCellModel(sender: "1@gmail.com", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
    MessageCellModel(sender: "2@gmail.com", text: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")]
    // swiftlint:enable line_length
}
