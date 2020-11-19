//
//  RequestSender.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 16.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

class RequestSender: RequestSenderProtocol {
    
    private func sessionFunc() -> URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }
    
    func send<Parser>(page: Int?, requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser: ParserProtocol {
        guard let urlRequest = config.request.urlRequest(page: page) else {
            completionHandler(Result.error("URL string can't be parsed to URL"))
            return
        }
        let session = sessionFunc()
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(Result.error("Recieved data can't be parsed"))
                    return
            }
            completionHandler(Result.success(parsedModel))
        }
        task.resume()
    }
}
