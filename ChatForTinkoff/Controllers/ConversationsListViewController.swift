//
//  ConversationsListViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var conversationList: UITableView!
    
    let headTitles = ["Channels"]
    var channels: [Channel] = []
    var channels_db: [Channel_db] = []
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationBarItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        conversationList.dataSource = self
        conversationList.delegate = self
        
        conversationList.register(UINib(nibName: Key.ConversationList.cellNibName, bundle: nil), forCellReuseIdentifier: Key.ConversationList.cellIdentifier)
        
        setupTheme()
        loadChannels()
        
    }
    
    func loadChannels() {
        reference.order(by: Key.FStore.lastActivity).addSnapshotListener { querySnapshot, error in
            self.channels = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        
                        let channelTimestamp = data[Key.FStore.lastActivity] as? Timestamp ??
                            Timestamp(date: Date(timeIntervalSince1970: 0))
                        let channelLastActivity = channelTimestamp.dateValue()
                        
                        let channelIdentifier = doc.documentID
                        let channelLastMessage = data[Key.FStore.lastMessage] as? String
                        if let channelName = data[Key.FStore.name] as? String {
                            let newChannel = Channel(identifier: channelIdentifier, name: channelName, lastMessage: channelLastMessage, lastActivity: channelLastActivity)
                            self.channels.append(newChannel)
                            
                            DispatchQueue.main.async {
                                self.conversationList.reloadData()
                            }
                        }
                    }
                    
                    self.makeRequest(channelsArray: self.channels)
                }
            }
        }
    }
    
    func makeRequest(channelsArray: [Channel]) {
            CoreDataStack.shared.performSave { context in
                channelsArray.forEach { channel in
                    let newChannel = Channel_db(context: context)
                    newChannel.identifier = channel.identifier
                    newChannel.name = channel.name
                    newChannel.lastMessage = channel.lastMessage
                    newChannel.lastActivity = channel.lastActivity
                    channels_db.append(newChannel)
                }
                CoreDataStack.shared.amountOfChannels()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func navigationBarItems() {
        title = "Tinkoff Chat"
        
        let profileButton = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "user"), style: .plain, target: self, action: #selector(profileImageIsTapped))
        let addChannelButton = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "plus-1"), style: .plain, target: self, action: #selector(addChannelIsTapped))
        
        navigationItem.rightBarButtonItems = [addChannelButton, profileButton]
        
        let settingsButton = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "settings-black"), style: .plain, target: self, action: #selector(settingsButtonIsTapped))
        navigationItem.setLeftBarButton(settingsButton, animated: true)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addChannelIsTapped() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Channel", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            if let chName = textField.text {
                self.reference.addDocument(data: [Key.FStore.name: chName, Key.FStore.lastMessage: "", Key.FStore.lastActivity: ""]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new channel"
            textField = alertTextField
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func settingsButtonIsTapped() {
        
        let themesStoryboard: UIStoryboard = UIStoryboard(name: Key.ThemesViewController.themeStoryBoard, bundle: nil)
        guard let themesViewController = themesStoryboard.instantiateViewController(withIdentifier: Key.ThemesViewController.themesVCId) as? ThemesViewController else { return }
        
        //       themesViewController.themesPickerDelegate = self
        themesViewController.themesClosure = { [weak self] in
            self?.setupTheme() }
        
        navigationController?.pushViewController(themesViewController, animated: false)
        themesViewController.title = "Settings"
        
    }
    
    @objc func profileImageIsTapped() {
        let storyboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: Key.NavigationProfileView.navigationProfileView)
        self.present(profileViewController, animated: true)
    }
    
    func setupTheme() {
        conversationList.backgroundColor = Theme.currentTheme.backgroundColor
        conversationList.tintColor = .white
        conversationList.reloadData()
        
        view.backgroundColor = Theme.currentTheme.backgroundColor
        
        navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        navigationController?.navigationBar.tintColor = Theme.currentTheme.textColor
        navigationController?.navigationBar.barStyle = Theme.currentTheme.barStyleColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        return headTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Key.ConversationList.cellIdentifier, for: indexPath) as? ConversationCell else { return UITableViewCell() }
        
        cell.configure(with: channels[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Key.StoryBoardName.mainStoryBoard, bundle: nil)
        
        guard let conversationViewController = mainStoryboard.instantiateViewController(withIdentifier: Key.Conversation.conversationVCId) as? ConversationViewController
            else { return }
        
        navigationController?.pushViewController(conversationViewController, animated: false)
        
        conversationViewController.title = channels[indexPath.row].name
        conversationViewController.identifier = channels[indexPath.row].identifier
        conversationViewController.channel = channels[indexPath.row]
//        conversationViewController.channelDB = channels_db[indexPath.row]
        
    }
}

// MARK: - ThemesPickerDelegate

extension ConversationsListViewController: ThemesPickerDelegate {
    func changeTheme(_ themesViewController: ThemesViewController) {
        
        setupTheme()
        
    }
}
