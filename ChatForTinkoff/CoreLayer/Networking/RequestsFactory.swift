//
//  RequestsFactory.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 16.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct Requests {
        static func newImageURLConfig() -> RequestConfig<ImageURLParser> {
            return RequestConfig<ImageURLParser>(request: ImageURLRequest(), parser: ImageURLParser())
        }
        
        static func newImageConfig(url: String) -> RequestConfig<ImageParser> {
            return RequestConfig<ImageParser>(request: ImageRequest(url: url), parser: ImageParser())
        }
    }
}
