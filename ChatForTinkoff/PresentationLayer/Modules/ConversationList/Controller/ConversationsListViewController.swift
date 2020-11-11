//
//  ConversationsListViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var conversationList: UITableView!
    
    let headTitles = ["Channels"]
    
    var conversationListModel: ConversationListProtocol?
    var presentationAssembly: PresentationAssemblyProtocol?
    
    lazy var fetchResultController: NSFetchedResultsController<Channel_db> = {
        let fetchRequest = NSFetchRequest<Channel_db>(entityName: "Channel_db")
        let sortedChannels = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortedChannels]
        fetchRequest.fetchBatchSize = 20
        guard let context = conversationListModel?.contextMain() else { return NSFetchedResultsController<Channel_db>() }
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: context,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarItems()
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        conversationList.dataSource = self
        conversationList.delegate = self
        
        conversationList.register(UINib(nibName: Key.ConversationList.cellNibName, bundle: nil), forCellReuseIdentifier: Key.ConversationList.cellIdentifier)
        
        setupTheme()
        fetchAllChannels()
        
    }
    
    func fetchAllChannels() {
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            conversationList.reloadData()
        } catch {
            print("\(error) smth wrong")
        }
        conversationListModel?.loadAllChannels()
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
                self.conversationListModel?.createNewChannel(chName: chName)
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
        guard let themesViewController = themesStoryboard.instantiateViewController(withIdentifier: Key.ThemesViewController.themesVCId) as? ThemesViewController
            else { return }
        
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
        conversationList.backgroundColor = ThemeManager.currentTheme.backgroundColor
        conversationList.tintColor = .white
        conversationList.reloadData()
        
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        
        navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme.backgroundColor
        navigationController?.navigationBar.tintColor = ThemeManager.currentTheme.textColor
        navigationController?.navigationBar.barStyle = ThemeManager.currentTheme.barStyleColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.textColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.textColor]
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchResultController.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        return headTitles[section]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return conversationList.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Key.ConversationList.cellIdentifier, for: indexPath) as? ConversationCell
            else { return UITableViewCell() }
        
        cell.configure(with: fetchResultController.object(at: indexPath))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversationViewController = presentationAssembly?.conversationViewController() else { return }
        
        navigationController?.pushViewController(conversationViewController, animated: true)
        let frc = fetchResultController.object(at: indexPath)
        conversationViewController.title = frc.name
        conversationViewController.identifier = frc.identifier
        conversationViewController.channel_db = frc
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = fetchResultController.object(at: indexPath)
            guard let id = channel.identifier else { return }
            conversationListModel?.deleteCurrentChannel(id: id, channel: channel)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - ThemesPickerDelegate

extension ConversationsListViewController: ThemesPickerDelegate {
    func changeTheme(_ themesViewController: ThemesViewController) {
        
        setupTheme()
        
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationList?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndex = newIndexPath {
                conversationList.insertRows(at: [newIndex], with: .none)
            }
        case .move:
            if let index = indexPath,
                let newIndex = newIndexPath {
                conversationList.deleteRows(at: [index], with: .none)
                conversationList.insertRows(at: [newIndex], with: .none)
            }
        case .update:
            if let index = indexPath,
                let cell = conversationList.cellForRow(at: index) as? ConversationCell {
                cell.configure(with: fetchResultController.object(at: index))
            }
        case .delete:
            if let index = indexPath {
                conversationList.deleteRows(at: [index], with: .none)
            }
        default:
            print("There is an error")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationList?.endUpdates()
    }
}

extension ConversationsListViewController: ConversationListDelegate {
    func completedLoad() {
        print("Loading Data complited successfully")
    }
}