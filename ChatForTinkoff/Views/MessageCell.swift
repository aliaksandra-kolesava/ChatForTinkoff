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
    @IBOutlet weak var incomingMessage: UIView!
    @IBOutlet weak var outgoingMessage: UIView!
    
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
        contentView.backgroundColor = Theme.currentTheme.backgroundColor
        
        if model.sender == "1@gmail.com" {
            incomingMessage.isHidden = true
            outgoingMessage.isHidden = false
            messageBubble.backgroundColor = Theme.currentTheme.incomingMessage
            messageLabel.textColor = Theme.currentTheme.incomingMessagesTextColor
        } else {
            incomingMessage.isHidden = false
            outgoingMessage.isHidden = true
            messageBubble.backgroundColor = Theme.currentTheme.outgoingMessage
            messageLabel.textColor = Theme.currentTheme.outgoingMessagesTextColor
        }
    }
}
