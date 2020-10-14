//
//  Theme.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 06.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    
    static var currentTheme: ThemeColors {

        if UserDefaults.standard.value(forKey: "chosenTheme") != nil {
            return ThemeColors(rawValue: UserDefaults.standard.integer(forKey: "chosenTheme"))!
        } else {
            return .classic
        }
    }
    
    static func updateTheme(_ theme: ThemeColors, completion: (() -> Void)?) {
        
        DispatchQueue.global(qos: .default).async {
             UserDefaults.standard.setValue(theme.rawValue, forKey: "chosenTheme")
             completion?()
        }
    }
}
