//
//  SwitchLogs.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 13.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

struct SwitchLogs {
    
    // To turn off logs change parameter to false
    var parameter: Bool = true
    
    func forAppDelegate(from: String, to: String, method: String) {
        if parameter {
        print("Application moved from <\(from)> to <\(to)>: \(method)")
        }
    }
    
    func forAppDelegate2(method: String) {
        if parameter {
        print("Application is in <Background> and is killed by the system or by the user: \(method)")
        }
    }
    
    func forViewControllers(method: String, numOfController: Int) {
        if parameter {
        print("\(method) for ViewController\(numOfController)")
        }
    }
}
