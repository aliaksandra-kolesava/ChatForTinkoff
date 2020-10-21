//
//  MessageCell.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 29.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = Message
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var incomingMessage: UIView!
    @IBOutlet weak var outgoingMessage: UIView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with model: Message) {
        messageLabel.text = model.content
        senderNameLabel.text = model.senderName
        contentView.backgroundColor = Theme.currentTheme.backgroundColor
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        createdLabel.text = formatter.string(from: model.created)
        
        if model.senderId == UIDevice.current.identifierForVendor?.uuidString ?? "" {
           incomingMessage.isHidden = true
            outgoingMessage.isHidden = false
            senderNameLabel.isHidden = true
            messageBubble.backgroundColor = Theme.currentTheme.incomingMessage
            messageLabel.textColor = Theme.currentTheme.incomingMessagesTextColor
            createdLabel.textColor = Theme.currentTheme.incomingMessagesTextColor
            
        } else {
            incomingMessage.isHidden = false
            outgoingMessage.isHidden = true
            senderNameLabel.isHidden = false
            messageBubble.backgroundColor = Theme.currentTheme.outgoingMessage
            messageLabel.textColor = Theme.currentTheme.outgoingMessagesTextColor
            senderNameLabel.textColor = Theme.currentTheme.outgoingMessagesTextColor
            createdLabel.textColor = Theme.currentTheme.outgoingMessagesTextColor
        }
    }
}
