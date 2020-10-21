//
//  Message.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 19.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}
