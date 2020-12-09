//
//  ImageRequest.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 16.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

class ImageURLRequest: RequestProtocol {
    
    func getValue(forKey key: String) -> String? {
        return Bundle.main.infoDictionary?[key] as? String
    }
    
    private func urlComponents(page: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pixabay.com"
        urlComponents.path = "/api/"
        
        guard let apiKey = getValue(forKey: "PIXABAY_API_KEY") else {
            fatalError("API_KEY not set in plist")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: "\(apiKey)"),
            URLQueryItem(name: "q", value: "yellow+flowers"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "25")]
        
        return urlComponents.url
    }
    
    func urlRequest(page: Int?) -> URLRequest? {
        guard let page = page,
            let url = urlComponents(page: page) else { return nil }
        let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
        return urlRequest
    }
    
}

class ImageRequest: RequestProtocol {
    
    var url: String
    init(url: String) {
        self.url = url
    }
    
    func urlRequest(page: Int?) -> URLRequest? {
        guard let url = URL(string: url) else { return  nil }
        return URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
    }
}
