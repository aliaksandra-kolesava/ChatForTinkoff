//
//  ConversationViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 28.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    var messageCells: [Message] = []
    
    var identifier: String?
    
    let mySenderName = "Aliaksandra Kolesava"
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.dataSource = self
        
        messagesTableView.register(UINib(nibName: Key.Conversation.cellNibName, bundle: nil), forCellReuseIdentifier: Key.Conversation.cellIdentifier)
        
        loadMessages()
        themeChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func themeChange() {
        
        messageTextField.backgroundColor = Theme.currentTheme.conversationListColor
        messageTextField.textColor = Theme.currentTheme.textColor
        messagesTableView.backgroundColor = Theme.currentTheme.backgroundColor
        textfieldView.backgroundColor = Theme.currentTheme.myProfileSaveButton
    }
    
    func loadMessages() {
        reference.document(identifier ?? "").collection("messages").addSnapshotListener { (querySnapshot, error) in
            self.messageCells = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDoc = querySnapshot?.documents {
                    for doc in snapshotDoc {
                        let messageData = doc.data()
                        
                        let messageCreated = messageData[Key.FStore.created] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                        let mesCreated = messageCreated.dateValue()
                        
                        if let mesContent = messageData[Key.FStore.content] as? String,
                            let mesSenderId = messageData[Key.FStore.senderId] as? String,
                            let mesSenderName = messageData[Key.FStore.senderName] as? String {
                            
                            let newMes = Message(identifier: self.identifier ?? "", content: mesContent, created: mesCreated, senderId: mesSenderId, senderName: mesSenderName)
                            self.messageCells.append(newMes)
                            
                            DispatchQueue.main.async {
                                self.messagesTableView.reloadData()
                                let indexPath = IndexPath(row: self.messageCells.count - 1, section: 0)
                                self.messagesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                    self.makeRequest(messagesArray: self.messageCells)
                }
            }
        }
    }
    
    func makeRequest(with request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest(), messagesArray: [Message]) {
        CoreDataStack.shared.performSave { (context) in
            let array = try? context.fetch(request)
            if let channelDB = array?.first {
                var mes_db: [Message_db] = []
                messagesArray.forEach { message in
                    let newMessage = Message_db(context: context)
                    newMessage.content = message.content
                    newMessage.created = message.created
                    newMessage.senderId = message.senderId
                    newMessage.senderName = message.senderName
                    newMessage.identifier = message.identifier
                    mes_db.append(newMessage)
                }
                mes_db.forEach { message in
                    channelDB.addToMessages_db(message)
                }
            }
             CoreDataStack.shared.messagesInCurrentChannel(channelsIdentifier: identifier ?? "")
             CoreDataStack.shared.amountOfMessages()
             CoreDataStack.shared.contentOfMessages(channelsIdentifier: identifier ?? "")
        }
    }

    @IBAction func messageButton(_ sender: UIButton) {
        if let messageContent = messageTextField.text, let messageSenderId = UIDevice.current.identifierForVendor?.uuidString {
            reference.document(identifier ?? "").collection("messages").addDocument(data: [
                Key.FStore.content: messageContent,
                Key.FStore.created: Timestamp(date: Date()),
                Key.FStore.senderId: messageSenderId,
                Key.FStore.senderName: mySenderName]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                        
                        DispatchQueue.main.async {
                            self.messageTextField.text = ""
                        }
                    }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sorted = messageCells.sorted {$0.created < $1.created}
        let message = sorted[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Key.Conversation.cellIdentifier, for: indexPath) as? MessageCell else { return UITableViewCell() }
        cell.configure(with: message)
        return cell
    }
}
