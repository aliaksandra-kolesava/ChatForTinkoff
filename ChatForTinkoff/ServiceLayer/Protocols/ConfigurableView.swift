//
//  Protocols.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 28.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
