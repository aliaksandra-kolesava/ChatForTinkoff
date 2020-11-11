//
//  FirebaseManager.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 10.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseManagerProtocol {
    func createChannel(chName: String)
    func loadChannels(completion: @escaping () -> Void)
    func deleteChannel(id: String, channel: Channel_db)
    func loadMessages(identifier: String?, completion: @escaping () -> Void)
    func addMessage(identifier: String?, messageContent: String, messageSenderId: String, mySenderName: String, completion: @escaping () -> Void)
    
}

class FirebaseManager: FirebaseManagerProtocol {
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    let coreDataStack: CoreDataStackProtocol
    let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataStack: CoreDataStackProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.coreDataStack = coreDataStack
        self.coreDataManager = coreDataManager
    }
    
    func createChannel(chName: String) {
        reference.addDocument(data: [Key.FStore.name: chName, Key.FStore.lastMessage: "", Key.FStore.lastActivity: ""]) { (error) in
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                print("Successfully saved data.")
            }
        }
    }
    
    func loadChannels(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async {
            self.reference.order(by: Key.FStore.lastActivity).addSnapshotListener { querySnapshot, error in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    querySnapshot?.documentChanges.forEach { diff in
                        
                        let data = diff.document.data()
                        let channelTimestamp = data[Key.FStore.lastActivity] as? Timestamp ??
                            Timestamp(date: Date(timeIntervalSince1970: 0))
                        let channelLastActivity = channelTimestamp.dateValue()
                        let channelIdentifier = diff.document.documentID
                        let channelLastMessage = data[Key.FStore.lastMessage] as? String
                        if let channelName = data[Key.FStore.name] as? String {
                            switch diff.type {
                            case .added:
                                self.coreDataManager.addChannel(channelIdentifier: channelIdentifier,
                                                                channelName: channelName,
                                                                channelLastMessage: channelLastMessage,
                                                                channelLastActivity: channelLastActivity)
                            case .modified:
                                self.coreDataManager.modifyChannel(channelIdentifier: channelIdentifier,
                                                                   channelName: channelName,
                                                                   channelLastMessage: channelLastMessage,
                                                                   channelLastActivity: channelLastActivity)
                            case .removed:
                                self.coreDataManager.removeChannel(channelIdentifier: channelIdentifier)
                            }
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func deleteChannel(id: String, channel: Channel_db) {
        reference.document(id).delete { (error) in
            if let error = error {
                print("Channel can't be deleted \(error.localizedDescription)")
            } else {
                self.coreDataStack.deleteChannel(channel: channel)
            }
        }
    }
    
    func loadMessages(identifier: String?, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async {
            self.reference.document(identifier ?? "").collection("messages").addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    querySnapshot?.documentChanges.forEach { diff in
                        switch diff.type {
                        case .added:
                            let messageData = diff.document.data()
                            let messageCreated = messageData[Key.FStore.created] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                            let mesCreated = messageCreated.dateValue()
                            
                            if let mesContent = messageData[Key.FStore.content] as? String,
                                let mesSenderId = messageData[Key.FStore.senderId] as? String,
                                let mesSenderName = messageData[Key.FStore.senderName] as? String {
                                
                                let newMes = Message(identifier: identifier ?? "", content: mesContent, created: mesCreated, senderId: mesSenderId, senderName: mesSenderName)
                                let messageIdentifier = diff.document.documentID
                                self.coreDataManager.addMessage(messageIdentifier: messageIdentifier, channelIdentifier: identifier ?? "", newMes: newMes)
                            }
                        case .modified:
                            break
                        case .removed:
                            break
                        }
                        completion()
                    }
                }
            }
        }
    }
    
    func addMessage(identifier: String?, messageContent: String, messageSenderId: String, mySenderName: String, completion: @escaping () -> Void) {
        reference.document(identifier ?? "").collection("messages").addDocument(data: [
            Key.FStore.content: messageContent,
            Key.FStore.created: Timestamp(date: Date()),
            Key.FStore.senderId: messageSenderId,
            Key.FStore.senderName: mySenderName]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    completion()
                }
        }
    }
}
