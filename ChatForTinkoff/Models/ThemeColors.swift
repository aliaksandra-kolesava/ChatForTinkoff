//
//  ThemeColors.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 05.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

enum ThemeColors: Int {
    case classic
    case day
    case night
    
    var backgroundColor: UIColor {
        switch self {
        case .classic:
            return .white
        case .day:
            return .white
        case .night:
            return .black
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .classic:
            return .black
        case .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var incomingMessage: UIColor {
        switch self {
        case .classic:
            return #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1)
        case .day:
            return #colorLiteral(red: 0.262745098, green: 0.537254902, blue: 0.9764705882, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
        }
    }
    
    var outgoingMessage: UIColor {
        switch self {
        case .classic:
            return #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
        case .day:
            return #colorLiteral(red: 0.9176470588, green: 0.9215686275, blue: 0.9294117647, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
        }
    }
    
    var outgoingMessagesTextColor: UIColor {
        switch self {
        case .classic:
            return .black
        case .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var incomingMessagesTextColor: UIColor {
        switch self {
        case .classic:
            return .black
        case .day:
            return .white
        case .night:
            return .white
        }
    }
    
    
    var myProfileSaveButton: UIColor {
        switch self {
        case .classic:
            return #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        case .day:
            return #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.1058823529, green: 0.1058823529, blue: 0.1058823529, alpha: 1)
        }
    }
    
    var myProfileTextColor: UIColor {
        switch self {
        case .classic:
            return .black
        case .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var settingsButtonColor: UIColor {
        switch self {
        case .classic:
            return .black
        case .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var conversationListOnline: UIColor {
        switch self {
        case .classic:
            return #colorLiteral(red: 1, green: 0.9529411765, blue: 0.8039215686, alpha: 1)
        case .day:
            return #colorLiteral(red: 1, green: 0.9529411765, blue: 0.8039215686, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
        }
    }
    var conversationListHistory: UIColor {
        switch self {
        case .classic:
            return .white
        case .day:
            return .white
        case .night:
            return #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
    }
    
    var barStyleColor: UIBarStyle {
        switch self {
        case .classic:
            return .default
        case .day:
            return .default
        case .night:
            return .black
        }
    }
    
    var cornerRadiusThemeButton: CGFloat {
        switch self {
        case .classic:
            return 14
        case .day:
            return 14
        case .night:
            return 14
        }
    }
        var borderColorThemeButton: CGColor {
            switch self {
            case .classic:
                return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            case .day:
                return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            case .night:
                return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            }
        }
        var borderWidthThemeButton: CGFloat {
            switch self {
            case .classic:
                return 5
            case .day:
                return 5
            case .night:
                return 5
            }
        }
        var clipsToBoundThemeButton: Bool {
            switch self {
            case .classic:
                return true
            case .day:
                return true
            case .night:
                return true
            }
        }
        var borderWidthThemeOtherButtons: CGFloat {
            switch self {
            case .classic:
                return 0
            case .day:
                return 0
            case .night:
                return 0
            }
        }
}
