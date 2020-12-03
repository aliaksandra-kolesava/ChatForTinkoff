//
//  CoreDataManager.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 09.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import CoreData
import Firebase

protocol CoreDataManagerProtocol {
    func addChannel(channelIdentifier: String, channelName: String, channelLastMessage: String?, channelLastActivity: Date?)
    func modifyChannel(channelIdentifier: String, channelName: String, channelLastMessage: String?, channelLastActivity: Date?)
    func removeChannel(channelIdentifier: String)
    func addMessage(messageIdentifier: String, channelIdentifier: String?, newMes: Message)
    
    func contextMain() -> NSManagedObjectContext?
}

class CoreDataManager: CoreDataManagerProtocol {
    
    let coreDataStack: CoreDataStackProtocol
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    func addChannel(channelIdentifier: String, channelName: String, channelLastMessage: String?, channelLastActivity: Date?) {
        let channelFetch: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        channelFetch.predicate = NSPredicate(format: "identifier = %@", channelIdentifier)
        coreDataStack.performSave { (context) in
            let array = try? context.fetch(channelFetch)
            let newChannel = array?.first
            if newChannel == nil {
                _ = Channel_db(name: channelName,
                               lastMessage: channelLastMessage,
                               lastActivity: channelLastActivity,
                               identifier: channelIdentifier,
                               in: context)
            } else {
                modifyChannel(channelIdentifier: channelIdentifier, channelName: channelName, channelLastMessage: channelLastMessage, channelLastActivity: channelLastActivity)
            }
        }
    }
    
    func modifyChannel(channelIdentifier: String, channelName: String, channelLastMessage: String?, channelLastActivity: Date?) {
        let channelFetch: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        channelFetch.predicate = NSPredicate(format: "identifier = %@", channelIdentifier)
        coreDataStack.performSave { (context) in
            let array = try? context.fetch(channelFetch)
            if let channel = array?.first {
                if channel.value(forKey: "name") as? String != channelName {
                    channel.setValue(channelName, forKey: "name")
                }
                if channel.value(forKey: "lastMessage") as? String != channelLastMessage {
                    channel.setValue(channelLastMessage, forKey: "lastMessage")
                }
                if channel.value(forKey: "lastActivity") as? Date != channelLastActivity {
                    channel.setValue(channelLastActivity, forKey: "lastActivity")
                }
            }
        }
    }
    
    func removeChannel(channelIdentifier: String) {
        let channelFetch: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        channelFetch.predicate = NSPredicate(format: "identifier = %@", channelIdentifier)
        coreDataStack.performSave { (context) in
            let array = try? context.fetch(channelFetch)
            if let channel = array?.first {
                context.delete(channel)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func addMessage(messageIdentifier: String, channelIdentifier: String?, newMes: Message) {
        let arrayChannel: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let arrayMessage: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        
        arrayMessage.predicate = NSPredicate(format: "identifier = %@", messageIdentifier)
        arrayChannel.predicate = NSPredicate(format: "identifier = %@", channelIdentifier ?? "")
        
        coreDataStack.performSave { (context) in
            let channelFetch = try? context.fetch(arrayChannel)
            let messageFetch = try? context.fetch(arrayMessage)
            if let channelDB = channelFetch?.first,
                messageFetch?.first == nil {
                let newMessage_db = Message_db(context: context)
                newMessage_db.content = newMes.content
                newMessage_db.created = newMes.created
                newMessage_db.identifier = messageIdentifier
                newMessage_db.senderId = newMes.senderId
                newMessage_db.senderName = newMes.senderName
                channelDB.addToMessages_db(newMessage_db)
            }
        }
    }
    
    func contextMain() -> NSManagedObjectContext? {
        return coreDataStack.mainContext
    }
}
