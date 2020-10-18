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
    
    init(file: String) {
        self.file = file
    }
    
    override func main() {
        if isCancelled { return }
        let data = Files.files.readFile(file: file)
        if isCancelled { return }
        self.data = data
    }
 }
 
 class  OperationWrite: Operation {
    let file: String
    let data: Data
    var result: Bool = false
    
    init(file: String, data: Data) {
        self.file = file
        self.data = data
        
        super.init()
    }
    
    override func main() {
        if isCancelled { return }
        let result = Files.files.writeFile(file: file, data: data)
        if isCancelled { return }
        self.result = result
    }
 }
 
 class OperationDataManager: DataManager {
    
    let operationQueue = OperationQueue()
    
    func readFile(file: String, callback: @escaping (Data?) -> Void) {
        let operationRead = OperationRead(file: file)
        
        operationRead.completionBlock = {
            OperationQueue.main.addOperation {
                callback(operationRead.data)
            }
        }
        operationQueue.addOperation(operationRead)
    }
    
    func writeFile(file: String, data: Data, callback: @escaping (Bool) -> Void) {
        let operationWrite = OperationWrite(file: file, data: data)
        
        operationWrite.completionBlock = {
            OperationQueue.main.addOperation {
                callback(operationWrite.result)
            }
        }
        
        operationQueue.addOperation(operationWrite)
    }
    
 }
