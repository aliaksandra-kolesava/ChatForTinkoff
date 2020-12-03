//
//  CoreAssembly.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 09.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

protocol CoreAssemblyProtocol {
    var coreDataStack: CoreDataStackProtocol { get }
    var files: FilesProtocol { get }
    var requestSender: RequestSenderProtocol { get }
}

class CoreAssembly: CoreAssemblyProtocol {
    var coreDataStack: CoreDataStackProtocol = CoreDataStack()
    var files: FilesProtocol = Files()
    var requestSender: RequestSenderProtocol = RequestSender()
}
