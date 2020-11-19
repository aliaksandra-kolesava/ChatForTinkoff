//
//  AvatarViewCell.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 15.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class AvatarViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarPic: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with avatar: UIImage?) {
        avatarPic.image = avatar
    }
}
