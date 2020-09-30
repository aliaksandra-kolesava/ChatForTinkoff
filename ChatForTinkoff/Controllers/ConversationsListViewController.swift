//
//  ConversationsListViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var conversationList: UITableView!
    
    let headTitles = ["Online", "History"]
    let conversationsExamples = ConversationsExamples()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarItems()
        
        conversationList.dataSource = self
        conversationList.delegate  = self
        
        conversationList.register(UINib(nibName: K.ConversationList.cellNibName, bundle: nil), forCellReuseIdentifier: K.ConversationList.cellIdentifier)
        
    }
    
    func navigationBarItems() {
        title = "Tinkoff Chat"
        var profileImage = #imageLiteral(resourceName: "user")
        profileImage = profileImage.withRenderingMode(.alwaysOriginal)
        let profileButton = UIBarButtonItem(image: profileImage, style: .done , target: self, action: #selector(self.profileImageIsTapped))
        navigationItem.rightBarButtonItem = profileButton
    }
    
    @objc func profileImageIsTapped() {
        let storyboard = UIStoryboard(name: K.StoryBoardName.mainStoryBoard, bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: K.NavigationProfileView.navigationProfileView)
        self.present(profileViewController, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return conversationsExamples.conversationCellModel.filter() {$0.isOnline}.count
        } else {
            return conversationsExamples.conversationCellModel.filter() {!$0.isOnline && $0.message != ""}.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        return headTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.ConversationList.cellIdentifier, for: indexPath) as? ConversationCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let sortedByDate = conversationsExamples.conversationCellModel.sorted() { $0.date > $1.date }
            let cellIsOnline = sortedByDate.filter() {$0.isOnline}
            cell.configure(with: cellIsOnline[indexPath.row])
            return cell
        } else {
            let sortedByDate = conversationsExamples.conversationCellModel.sorted() { $0.date > $1.date }
            let cellIsHistory = sortedByDate.filter() {!$0.isOnline && $0.message != ""}
            cell.configure(with: cellIsHistory[indexPath.row])
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: K.StoryBoardName.mainStoryBoard, bundle: nil)
        let conversationViewController = mainStoryboard.instantiateViewController(withIdentifier: K.Conversation.conversationViewControllerId) as! ConversationViewController
        navigationController?.pushViewController(conversationViewController, animated: false)
        
        if indexPath.section == 0 {
            let sortedByDate = conversationsExamples.conversationCellModel.sorted() { $0.date > $1.date }
            let cellIsOnline = sortedByDate.filter() {$0.isOnline}
            conversationViewController.title = cellIsOnline[indexPath.row].name
        } else {
            let sortedByDate = conversationsExamples.conversationCellModel.sorted() { $0.date > $1.date }
            let cellIsHistory = sortedByDate.filter() {!$0.isOnline && $0.message != ""}
            conversationViewController.title = cellIsHistory[indexPath.row].name
        
        }
    }
}
