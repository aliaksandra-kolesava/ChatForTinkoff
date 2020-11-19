//
//  ImageParser.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 16.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

struct PictureData: Codable {
    let hits: [Pictures]
}

struct Pictures: Codable {
    let webformatURL: String
}

class ImageURLParser: ParserProtocol {
    typealias Model = [Pictures]
    
    func parse(data: Data) -> [Pictures]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PictureData.self, from: data)
            let pictures = decodedData.hits
            return pictures
        } catch {
            print("\(error.localizedDescription) trying to convert data to JSON")
            return nil
        }
    }
}

class ImageParser: ParserProtocol {
    
    typealias Model = UIImage
    
    func parse(data: Data) -> Model? {
        guard let picture = UIImage(data: data)  else { return nil }
        return picture
    }
}
