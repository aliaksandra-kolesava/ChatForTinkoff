//
//  Files.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 12.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

class Files {
    
    static let files = Files()
    
    let fileWithData: String = "fileWithData.plist"
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func readFile(file: String) -> Data? {
        guard let fileURL = dataFilePath?.appendingPathComponent(file) else { return(nil) }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            return nil
        }
    }
    
    func writeFile(file: String, data: Data) -> Bool {
        let previousData =  readFile(file: file)
        
        if previousData == data {
            return true
        }
        
        guard let fileURL = dataFilePath?.appendingPathComponent(file) else { return false }
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            return false
        }
    }
}
