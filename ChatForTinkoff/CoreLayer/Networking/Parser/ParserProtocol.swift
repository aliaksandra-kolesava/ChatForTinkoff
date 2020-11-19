//
//  ParserProtocol.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 16.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}
