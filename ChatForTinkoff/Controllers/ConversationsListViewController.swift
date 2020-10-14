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
        
        setupTheme()
        
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

        let profileButton = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "user"), style: .plain , target: self, action: #selector(profileImageIsTapped))
        navigationItem.rightBarButtonItem = profileButton

        let settingsButton = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "settings-black") , style: .plain, target: self, action: #selector(settingsButtonIsTapped))
        navigationItem.setLeftBarButton(settingsButton, animated: true)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func settingsButtonIsTapped() {
       
        let themesStoryboard: UIStoryboard = UIStoryboard(name: K.ThemesViewController.themeStoryBoard, bundle: nil)
        guard let themesViewController = themesStoryboard.instantiateViewController(withIdentifier: K.ThemesViewController.themesViewControllerId) as? ThemesViewController else { return }
        
//       themesViewController.themesPickerDelegate = self
        themesViewController.themesClosure = { [weak self] in
            self?.setupTheme() }
        
       navigationController?.pushViewController(themesViewController, animated: false)
       themesViewController.title = "Settings"

    }
    
    @objc func profileImageIsTapped() {
        let storyboard = UIStoryboard(name: K.StoryBoardName.mainStoryBoard, bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: K.NavigationProfileView.navigationProfileView)
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
        guard let conversationViewController = mainStoryboard.instantiateViewController(withIdentifier: K.Conversation.conversationViewControllerId) as? ConversationViewController else { return }
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

//MARK: - ThemesPickerDelegate

extension ConversationsListViewController: ThemesPickerDelegate {
    func changeTheme(_ themesViewController: ThemesViewController) {
        
        setupTheme()
        
    }
}
