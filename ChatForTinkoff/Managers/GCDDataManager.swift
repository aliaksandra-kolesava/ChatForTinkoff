//
//  GCDDataManager.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 12.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

class GCDDataManager: DataManager {
    
    let queue = DispatchQueue.global(qos: .utility)
    
    func readFile(file: String, callback: @escaping (Data?) -> Void) {
        queue.async {
            let data = Files.files.readFile(file: file)
            
            DispatchQueue.main.async {
                callback(data)
            }
        }
      }
    
    func writeFile(file: String, data: Data, callback: @escaping (Bool) -> Void) {
        queue.async {
            let result = Files.files.writeFile(file: file, data: data)
            
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }
    
    
}
