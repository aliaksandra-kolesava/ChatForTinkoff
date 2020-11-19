//
//  AvatarModel.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 17.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

protocol AvatarModelProtocol {
    var arrayOfPictures: [Pictures] { get set }
    func loadPicturesURL()
    func loadPictures(url: String, completion: @escaping (UIImage?) -> Void)
    func amountOfPictures() -> [Pictures]
    
}

protocol AvatarDelegate: class {
    func loadComplited()
}

protocol SaveAvatarPicture: class {
    func setProfile(image: UIImage?, url: String)
}

class AvatarModel: AvatarModelProtocol {
    
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    weak var delegate: AvatarDelegate?
    weak var saveAvatarPicureDelegate: SaveAvatarPicture?
    
    private var page = 0
    var arrayOfPictures: [Pictures] = []
    
    
    func loadPicturesURL() {
        page += 1
        networkManager.loadNewPicturesURL(page: page) { (images, error) in
            if let error = error {
                print(error)
                return
            }
            guard let images = images else { return }
                self.arrayOfPictures.append(contentsOf: images)
                self.delegate?.loadComplited()
        }
    }
    
    func loadPictures(url: String, completion: @escaping (UIImage?) -> Void) {
        let picture = networkManager.checkCache(url: url)
        guard let image = picture else {
            self.networkManager.loadNewPicrures(url: url) { (loadingImage, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let loadingPicture = loadingImage else { return }
                self.networkManager.saveToCache(url: url, picture: loadingPicture)
                completion(loadingPicture)
            }
            return
        }
        completion(image)
    }
    
    func amountOfPictures() -> [Pictures] {
        print("AvatarModel: \(arrayOfPictures)")
        return arrayOfPictures
    }
}
