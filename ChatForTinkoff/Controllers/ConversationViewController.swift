//
//  ConversationViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 28.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    var messagesExamples = MessagesExample()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.dataSource = self
        
        messagesTableView.register(UINib(nibName: K.Conversation.cellNibName, bundle: nil), forCellReuseIdentifier: K.Conversation.cellIdentifier)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messagesExamples.messages.count - 1, section: 0)
            self.messagesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

//MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesExamples.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messagesExamples.messages[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.Conversation.cellIdentifier, for: indexPath) as? MessageCell else { return UITableViewCell() }
        cell.configure(with: message)
        return cell
    }
}
