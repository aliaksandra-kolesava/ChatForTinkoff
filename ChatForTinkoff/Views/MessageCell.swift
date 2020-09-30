//
//  MessageCell.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 29.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = MessageCellModel
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var incomeMessage: UIView!
    @IBOutlet weak var outcomeMessage: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        
        if model.sender == "1@gmail.com" {
            incomeMessage.isHidden = true
            outcomeMessage.isHidden  = false
            messageBubble.backgroundColor = #colorLiteral(red: 0.8580739776, green: 0.8290178988, blue: 0.8094866488, alpha: 1)
        }
        else {
            incomeMessage.isHidden = false
            outcomeMessage.isHidden = true
            messageBubble.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }
    }
}
