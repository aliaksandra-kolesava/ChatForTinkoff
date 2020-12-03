//
//  CoreDataStackMock.swift
//  ChatForTinkoffTests
//
//  Created by Александра Колесова on 01.12.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

@testable import ChatForTinkoff
import Foundation
import CoreData

class CoreDataStackMock: CoreDataStackProtocol {
    
    var mainContext: NSManagedObjectContext?
    var performSaveCount = 0
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        performSaveCount += 1
    }
}

class RequestSenderMock: RequestSenderProtocol {
    var requestCount = 0
    func send<Parser>(page: Int?, requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: ParserProtocol {
        requestCount += 1
    }
}
