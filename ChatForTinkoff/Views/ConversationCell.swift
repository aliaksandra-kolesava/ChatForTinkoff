//
//  ConversationCell.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = ConversationCellModel
    
    
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
    
    func configure(with model: ConversationCellModel) {
        nameLabel.text  = model.name
        
        if model.message == "" {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: 13)
        }
        else {
            messageLabel.text = model.message
        }
        
        if Calendar.current.isDateInToday(model.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            if model.message == "" {
                dateLabel.text = ""
            }
            else {
            dateLabel.text = formatter.string(from: model.date)
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            if model.message == "" {
                dateLabel.text = ""
            }
            else {
            dateLabel.text = formatter.string(from: model.date)
            }
        }
        
        if model.isOnline {
            contentView.backgroundColor = #colorLiteral(red: 1, green: 0.9529411765, blue: 0.8039215686, alpha: 1)
        }
        if model.hasUnreadMessages {
            messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
}
