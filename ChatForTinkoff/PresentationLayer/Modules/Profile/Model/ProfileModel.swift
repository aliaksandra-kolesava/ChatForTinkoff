//
//  ProfileModel.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 12.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileProtocol {

    func readFile(file: String, callback: @escaping (Data?) -> Void)
    func writeFile(file: String, data: Data, callback: @escaping (Bool) -> Void)
    func fileWithData() -> String
    var dataManager: DataManagerProtocol? { get set }
}

class ProfileModel: ProfileProtocol {
    
    weak var dataManager: DataManagerProtocol?
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func readFile(file: String, callback: @escaping (Data?) -> Void) {
        dataManager?.readFile(file: file, callback: callback)
    }
      
    func writeFile(file: String, data: Data, callback: @escaping (Bool) -> Void) {
        dataManager?.writeFile(file: file, data: data, callback: callback)
    }
      
    func fileWithData() -> String {
        dataManager?.fileWithData() ?? ""
    }
}
