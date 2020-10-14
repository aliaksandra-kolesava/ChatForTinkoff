//
//  DataManager.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 12.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

protocol DataManager {
    func readFile(file: String, callback: @escaping (Data?) -> Void)
    func writeFile(file: String, data: Data, callback: @escaping (Bool) -> Void)
}
