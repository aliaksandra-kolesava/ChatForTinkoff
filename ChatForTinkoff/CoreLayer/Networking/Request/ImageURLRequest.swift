//
//  ImageRequest.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 16.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation

class ImageURLRequest: RequestProtocol {
    
    //https://pixabay.com/api/?key=19122176-97020ac78cbd69103da6f8991&q=yellow+flowers&image_type=photo
    
    private func urlComponents(page: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pixabay.com"
        urlComponents.path = "/api/"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: "19122176-97020ac78cbd69103da6f8991"),
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
