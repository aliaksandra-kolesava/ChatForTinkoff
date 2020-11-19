//
//  NetworkManager.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 17.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkManagerProtocol {
    func loadNewPicturesURL(page: Int?, completionHandler: @escaping ([Pictures]?, String?) -> Void)
    func loadNewPicrures(url: String, completion: @escaping (UIImage?, String?) -> Void)
    func checkCache(url: String) -> UIImage?
    func saveToCache(url: String, picture: UIImage)
}

class NetworkManager: NetworkManagerProtocol {
    let requestSender: RequestSenderProtocol
    
    init(requestSender: RequestSenderProtocol) {
        self.requestSender = requestSender
    }
    
    var cache = NSCache<NSString, UIImage>()
    
    func loadNewPicturesURL(page: Int?, completionHandler: @escaping ([Pictures]?, String?) -> Void) {
        let  requestConfig = RequestsFactory.Requests.newImageURLConfig()
        requestSender.send(page: page, requestConfig: requestConfig) { (result: Result<[Pictures]>) in
            switch result {
            case .success(let pictures):
                completionHandler(pictures, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadNewPicrures(url: String, completion: @escaping (UIImage?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageConfig(url: url)
        requestSender.send(page: nil, requestConfig: requestConfig) { (result: Result<UIImage>) in
            switch result {
            case .success(let pictures):
                completion(pictures, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    func checkCache(url: String) -> UIImage? {
        if let cache = cache.object(forKey: url as NSString) {
            return cache
        }
        return nil
    }
    
    func saveToCache(url: String, picture: UIImage) {
        cache.setObject(picture, forKey: url as NSString)
    }
}
