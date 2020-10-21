//
//  Channel.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 19.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
