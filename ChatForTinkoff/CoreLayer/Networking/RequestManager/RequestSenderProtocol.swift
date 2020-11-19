//
//  RequestSenderProtocol.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 16.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}

enum Result<Model> {
    case success(Model)
    case error(String)
}

protocol RequestSenderProtocol {
    func send<Parser>(page: Int?, requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model>) -> Void)
}
