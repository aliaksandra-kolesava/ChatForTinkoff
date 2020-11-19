//
//  RequestProtocol.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 16.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    func urlRequest(page: Int?) -> URLRequest?
}
