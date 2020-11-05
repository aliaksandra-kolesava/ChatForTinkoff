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
    
    var identifier: String?
    var channel_db: Channel_db?
    
    lazy var fetchResultController: NSFetchedResultsController<Message_db>? = {
        let fetchRequest = NSFetchRequest<Message_db>(entityName: "Message_db")
        let sortedChannels = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sortedChannels]
        guard let channel_db = channel_db else { return nil }
        
        let predicate = NSPredicate(format: "channel_db.identifier = %@", channel_db.identifier ?? "")
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: CoreDataStack.shared.mainContext,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    let mySenderName = "Aliaksandra Kolesava"
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.dataSource = self
        
        messagesTableView.register(UINib(nibName: Key.Conversation.cellNibName, bundle: nil), forCellReuseIdentifier: Key.Conversation.cellIdentifier)
        messagesTableView?.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        themeChange()
        fetchAllMessages()
        
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
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                querySnapshot?.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        let messageData = diff.document.data()
                        let messageCreated = messageData[Key.FStore.created] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                        let mesCreated = messageCreated.dateValue()
                        
                        if let mesContent = messageData[Key.FStore.content] as? String,
                            let mesSenderId = messageData[Key.FStore.senderId] as? String,
                            let mesSenderName = messageData[Key.FStore.senderName] as? String {
                            
                            let newMes = Message(identifier: self.identifier ?? "", content: mesContent, created: mesCreated, senderId: mesSenderId, senderName: mesSenderName)
                            let messageIdentifier = diff.document.documentID
                            let arrayChannel: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
                            let arrayMessage: NSFetchRequest<Message_db> = Message_db.fetchRequest()

                            arrayMessage.predicate = NSPredicate(format: "identifier = %@", messageIdentifier)
                            arrayChannel.predicate = NSPredicate(format: "identifier = %@", self.identifier ?? "")
                            
                            CoreDataStack.shared.performSave { (context) in
                                let channelFetch = try? context.fetch(arrayChannel)
                                let messageFetch = try? context.fetch(arrayMessage)
                                if let channelDB = channelFetch?.first,
                                messageFetch?.first == nil {
                                    let newMessage_db = Message_db(context: context)
                                    newMessage_db.content = newMes.content
                                    newMessage_db.created = newMes.created
                                    newMessage_db.identifier = messageIdentifier
                                    newMessage_db.senderId = newMes.senderId
                                    newMessage_db.senderName = newMes.senderName
                                    channelDB.addToMessages_db(newMessage_db)
                                    
                                }
                            }
                        }
                    case .modified:
                        break
                    case .removed:
                        break
                    }
                }
            }
        }
    }

    func fetchAllMessages() {
        fetchResultController?.delegate = self
        
        do {
            try fetchResultController?.performFetch()
        } catch {
            print(error)
        }
        loadMessages()
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
        guard let sections = fetchResultController?.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return messagesTableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Key.Conversation.cellIdentifier, for: indexPath) as? MessageCell else { return UITableViewCell() }
        guard let message = fetchResultController?.object(at: indexPath) else { return UITableViewCell() }
        cell.configure(with: message)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndex = newIndexPath {
                messagesTableView.insertRows(at: [newIndex], with: .none)
            }
        case .move:
            if let index = indexPath,
                let newIndex = newIndexPath {
                messagesTableView.deleteRows(at: [index], with: .none)
                messagesTableView.insertRows(at: [newIndex], with: .none)
            }
        case .update:
            if let index = indexPath,
                let cell = messagesTableView.cellForRow(at: index) as? MessageCell,
                let message = fetchResultController?.object(at: index) {
                cell.configure(with: message)
            }
        case .delete:
            if let index = indexPath {
                messagesTableView.deleteRows(at: [index], with: .none)
            }
        default:
            print("There is an error")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        messagesTableView.endUpdates()
    }
}
