//
//  OperationDataManager.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 12.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
 
 class OperationRead: Operation {
    var file: String
    var data: Data?
    
    let files: FilesProtocol
    
    init(file: String, files: FilesProtocol) {
        self.file = file
        self.files = files
    }
    
    override func main() {
        if isCancelled { return }
        let data = files.readFile(file: file)
        if isCancelled { return }
        self.data = data
    }
 }
 
 class  OperationWrite: Operation {
    let file: String
    let data: Data
    var result: Bool = false
    
    let files: FilesProtocol
    
    init(file: String, data: Data, files: FilesProtocol) {
        self.file = file
        self.data = data
        self.files = files
        
        super.init()
    }
    
    override func main() {
        if isCancelled { return }
        let result = files.writeFile(file: file, data: data)
        if isCancelled { return }
        self.result = result
    }
 }
 
 class OperationDataManager: DataManagerProtocol {
    
    let operationQueue = OperationQueue()
    let files: FilesProtocol
    
    init(files: FilesProtocol) {
        self.files = files
    }
    
    func fileWithData() -> String {
        return files.fileWithData()
    }
    
    func readFile(file: String, callback: @escaping (Data?) -> Void) {
        let operationRead = OperationRead(file: file, files: files)
        
        operationRead.completionBlock = {
            OperationQueue.main.addOperation {
                callback(operationRead.data)
            }
        }
        operationQueue.addOperation(operationRead)
    }
    
    func writeFile(file: String, data: Data, callback: @escaping (Bool) -> Void) {
        let operationWrite = OperationWrite(file: file, data: data, files: files)
        
        operationWrite.completionBlock = {
            OperationQueue.main.addOperation {
                callback(operationWrite.result)
            }
        }
        
        operationQueue.addOperation(operationWrite)
    }
    
 }
