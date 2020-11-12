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
    
    typealias ConfigurationModel = Message_db
    
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
    
    func configure(with model: Message_db) {
        messageLabel.text = model.content
        senderNameLabel.text = model.senderName
        contentView.backgroundColor = ThemeManager.currentTheme.backgroundColor
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        createdLabel.text = formatter.string(from: model.created ?? Date())
        
        if model.senderId == UIDevice.current.identifierForVendor?.uuidString ?? "" {
            labelsAreHidden(state: true)
            outgoingMessage.isHidden = false
            messageBubble.backgroundColor = ThemeManager.currentTheme.incomingMessage
            messageLabel.textColor = ThemeManager.currentTheme.incomingMessagesTextColor
            createdLabel.textColor = ThemeManager.currentTheme.incomingMessagesTextColor
            
        } else {
            labelsAreHidden(state: false)
            outgoingMessage.isHidden = true
            messageBubble.backgroundColor = ThemeManager.currentTheme.outgoingMessage
            messageLabel.textColor = ThemeManager.currentTheme.outgoingMessagesTextColor
            senderNameLabel.textColor = ThemeManager.currentTheme.outgoingMessagesTextColor
            createdLabel.textColor = ThemeManager.currentTheme.outgoingMessagesTextColor
        }
    }
    
    func labelsAreHidden(state: Bool) {
        incomingMessage.isHidden = state
        senderNameLabel.isHidden = state
    }
}
