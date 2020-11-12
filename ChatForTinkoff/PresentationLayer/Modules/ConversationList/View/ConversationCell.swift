//
//  ConversationCell.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit
import Firebase

class ConversationCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = Channel_db
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with model: Channel_db) {
        nameLabel.text = model.name
        contentView.backgroundColor = ThemeManager.currentTheme.conversationListColor
        nameLabel.textColor = ThemeManager.currentTheme.textColor
        messageLabel.textColor = ThemeManager.currentTheme.textColor
        
        if model.lastMessage == nil || model.lastMessage == "" {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: 13)
        } else {
            messageLabel.text = model.lastMessage
        }
        
        if let lastActivity = model.lastActivity {
            if Calendar.current.isDateInToday(lastActivity) {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                if model.lastMessage == nil || model.lastMessage == "" {
                    dateLabel.text = ""
                } else {
                    dateLabel.text = formatter.string(from: lastActivity)
                }
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM"
                if model.lastMessage == nil || model.lastMessage == "" {
                    dateLabel.text = ""
                } else {
                    dateLabel.text = formatter.string(from: lastActivity)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
}
