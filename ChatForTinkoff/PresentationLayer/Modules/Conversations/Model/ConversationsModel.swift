//
//  ConversationsModel.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 10.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationsModelProtocol: class {
    var delegate: ConversationsProtocol? { get set }
    func loadMessages(identifier: String?)
    func addMessage(identifier: String?, messageContent: String, messageSenderId: String, mySenderName: String)
    func contextMain() -> NSManagedObjectContext
}

protocol ConversationsProtocol: class {
    func clearTextfield()
}

class ConversationsModel: ConversationsModelProtocol {
    weak var delegate: ConversationsProtocol?
    
    let coreDataManager: CoreDataManagerProtocol
    let firebaseDataManager: FirebaseManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol, firebaseDataManager: FirebaseManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.firebaseDataManager = firebaseDataManager
    }
    
    func loadMessages(identifier: String?) {
        firebaseDataManager.loadMessages(identifier: identifier)
    }
    
    func addMessage(identifier: String?, messageContent: String, messageSenderId: String, mySenderName: String) {
        firebaseDataManager.addMessage(identifier: identifier, messageContent: messageContent, messageSenderId: messageSenderId, mySenderName: mySenderName) {
            self.delegate?.clearTextfield()
        }
    }
    
    func contextMain() -> NSManagedObjectContext {
        return coreDataManager.contextMain()
    }
    
}
