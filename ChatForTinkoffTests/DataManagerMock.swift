//
//  FirebaseManagerMock.swift
//  ChatForTinkoffTests
//
//  Created by Александра Колесова on 29.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

@testable import ChatForTinkoff
import Foundation

class DataManagerMock: ReadAndWriteDataProtocol {

    var readFileCount = 0
    var writeFileCount = 0
    var fileName = "fileWithData.plist"
    var dataRead: Data?
    var dataWritten: Data?
    var boolWrite = true
    var readFileStub: (((Data?) -> Void) -> Void)!
    
    func readFile(file: String) -> Data? {
        fileName = file
        readFileCount += 1
        return dataRead
    }
    
    func writeFile(file: String, data: Data) -> Bool {
        fileName = file
        dataWritten = data
        writeFileCount += 1
        return boolWrite
    }
    
    func fileName() -> String {
        return fileName
    }
}
