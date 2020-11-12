//
//  ObjectsExtensions.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import CoreData

extension Channel_db {
    convenience init(name: String,
                     lastMessage: String?,
                     lastActivity: Date?,
                     identifier: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.identifier = identifier
    }
}

extension Message_db {
    convenience init(identifier: String,
                     content: String,
                     created: Date,
                     senderId: String,
                     senderName: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
}
