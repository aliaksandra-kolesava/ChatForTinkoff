//
//  ConversationListModel.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 10.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import CoreData
import Firebase

protocol ConversationListProtocol: class {
    var delegate: ConversationListDelegate? { get set }
    func loadAllChannels()
    func createNewChannel(chName: String)
    func deleteCurrentChannel(id: String, channel: Channel_db)
    func contextMain() -> NSManagedObjectContext?
}

protocol ConversationListDelegate: class {
    func completedLoad()
}
class ConversationListModel: ConversationListProtocol {
    
    weak var delegate: ConversationListDelegate?
    
    let firebaseDataManager: FirebaseManagerProtocol
    let coreDataManager: CoreDataManagerProtocol
    
    init(firebaseDataManager: FirebaseManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.firebaseDataManager = firebaseDataManager
        self.coreDataManager = coreDataManager
    }
    
    func loadAllChannels() {
        firebaseDataManager.loadChannels()
    }
    
    func createNewChannel(chName: String) {
        firebaseDataManager.createChannel(chName: chName)
    }
    
    func deleteCurrentChannel(id: String, channel: Channel_db) {
        firebaseDataManager.deleteChannel(id: id, channel: channel)
    }
    
    func contextMain() -> NSManagedObjectContext? {
        return coreDataManager.contextMain()
    }
}
