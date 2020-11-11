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
//    var themeManager: ThemeManagerProtocol { get }
//    var files: FilesProtocol { get }
//    var operationDataManager: DataManagerProtocol { get }
//    var gcdDataManager: DataManagerProtocol { get }
}

class ServiceAssembly: ServiceAssemblyProtocol {
    
    private let coreAssembly: CoreAssemblyProtocol
    
    init(coreAssembly: CoreAssemblyProtocol) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var coreDataManager: CoreDataManagerProtocol = CoreDataManager(coreDataStack: coreAssembly.coreDataStack)
    lazy var firebaseManager: FirebaseManagerProtocol = FirebaseManager(coreDataStack: coreAssembly.coreDataStack, coreDataManager: coreDataManager)
//    lazy var themeManager: ThemeManagerProtocol = ThemeManager()
//    lazy var files: FilesProtocol = Files()
//    lazy var operationDataManager: DataManagerProtocol = OperationDataManager()
//    lazy var gcdDataManager: DataManagerProtocol = GCDDataManager()
    
}
