//
//  ProfileInfo.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 12.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

class ProfileInfo: NSObject, NSCoding {
    
    var name: String
    var aboutYourself: String
    var profileImage: UIImage

    init(name: String, aboutYourself: String, profileImage: UIImage) {
        self.name = name
        self.aboutYourself = aboutYourself
        self.profileImage = profileImage
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let imageData = aDecoder.decodeObject(forKey: Key.ProfileInfoKeys.imageData) as? Data,
            let name = aDecoder.decodeObject(forKey: Key.ProfileInfoKeys.nameData) as? String,
            let aboutYourself = aDecoder.decodeObject(forKey: Key.ProfileInfoKeys.aboutYourselfData) as? String,
            let profileImage = UIImage(data: imageData) else { return nil }

        self.init(name: name, aboutYourself: aboutYourself, profileImage: profileImage)
       }

       func encode(with aCoder: NSCoder) {
           let imageData = profileImage.pngData()
           aCoder.encode(imageData, forKey: Key.ProfileInfoKeys.imageData)

           aCoder.encode(self.name, forKey: Key.ProfileInfoKeys.nameData)
           aCoder.encode(self.aboutYourself, forKey: Key.ProfileInfoKeys.aboutYourselfData)
       }
}