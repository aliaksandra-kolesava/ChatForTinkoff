//
//  ServiceAssembly.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 10.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

protocol ServiceAssemblyProtocol {
    var coreDataManager: CoreDataManagerProtocol { get }
    var firebaseManager: FirebaseManagerProtocol { get }
    
    var gcdDataManager: DataManagerProtocol { get }
    var operationDataManager: DataManagerProtocol { get }
    var networkManager: NetworkManagerProtocol { get }
}

class ServiceAssembly: ServiceAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var coreDataManager: CoreDataManagerProtocol = CoreDataManager(coreDataStack: coreAssembly.coreDataStack)
    lazy var firebaseManager: FirebaseManagerProtocol = FirebaseManager(coreDataStack: coreAssembly.coreDataStack, coreDataManager: coreDataManager)
    lazy var gcdDataManager: DataManagerProtocol = GCDDataManager(files: coreAssembly.files)
    lazy var operationDataManager: DataManagerProtocol = OperationDataManager(files: coreAssembly.files)
    lazy var networkManager: NetworkManagerProtocol = NetworkManager(requestSender: coreAssembly.requestSender)
}
