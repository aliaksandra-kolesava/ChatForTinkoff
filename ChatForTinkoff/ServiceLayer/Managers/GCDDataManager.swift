//
//  GCDDataManager.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 12.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

class GCDDataManager: DataManagerProtocol {
  
    let files: FilesProtocol
    init(files: FilesProtocol) {
        self.files = files
    }
    
    let queue = DispatchQueue.global(qos: .utility)
    
    func fileWithData() -> String {
        return files.fileWithData()
    }
    
    func readFile(file: String, callback: @escaping (Data?) -> Void) {
        queue.async {
            let data = self.files.readFile(file: file)
            
            DispatchQueue.main.async {
                callback(data)
            }
        }
      }
    
    func writeFile(file: String, data: Data, callback: @escaping (Bool) -> Void) {
        queue.async {
            let result = self.files.writeFile(file: file, data: data)
            
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }
    
}
