//
//  ProfileViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 13.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var aboutYourself: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var firstLetterName: UILabel!
    @IBOutlet weak var firstLetterSurname: UILabel!
    
    var switchLogs = SwitchLogs()
    var imagePicker = UIImagePickerController()
    var letterName: String = ""
    var letterSurname: String = ""
    var name: String? = "Marina Dudarenko"
    var text = "UX/UI designer, web-designer Moscow, Russia"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //print(editButton.frame)
        //кнопка еще не инициализирована, поэтому ее значение frame = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchLogs.forProfileViewController(method: "\(#function)")
        editingProfile()
        profileName.text = name
        
        if profileName.text != nil {
            firstLetterName.text = initialsName(name: profileName.text ?? "")

        if initialsSurname(name: profileName.text ?? "") != "" {
            firstLetterSurname.text = initialsSurname(name: profileName.text ?? "")
        } else {
            firstLetterSurname.isHidden = true
        }
        } else {
            firstLetterName.text = ""
            firstLetterSurname.text = ""
        }
        aboutYourself.text = text
        
        print(editButton.frame)
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(editButton.frame)
        //значения не совпадают, потому что в методе viewDidAppear экран уже загрузился и значения frame меняются на более точные в зависимости от выбранного утсройства и применения Auto LayOut, в то время как в viewDidLoad пишутся значения указанные при верстки в storyboard
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    
    //MARK: - The Initial Edition Profile
    
    func editingProfile() {
        profilePhoto.layer.cornerRadius = profilePhoto.bounds.size.width / 2
        saveButton.layer.cornerRadius = saveButton.bounds.size.height / 3
        
        profileName.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        aboutYourself.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        firstLetterName.font = UIFont.systemFont(ofSize: 120, weight: .regular)
        firstLetterSurname.font = UIFont.systemFont(ofSize: 120, weight: .regular)
        
        profilePhoto.image = #imageLiteral(resourceName: "profilePhoto(e4e82b)-1")
        
    }
    
    //MARK: - Functions for Initials
    
    func initialsName(name: String) -> String {
        let firstLetter = name[name.startIndex]
        let firstLetterString = String(firstLetter)
        return firstLetterString
    }
    func initialsSurname(name: String) -> String {
        let fullNameArr = name.components(separatedBy: " ")
        let numberOfWords = fullNameArr.count
        if numberOfWords > 1 {
            let surname = fullNameArr[1]
            let firstLetter = surname[surname.startIndex]
            let firstLetterString = String(firstLetter)
            return firstLetterString
        } else {
            return ""
        }
    }
    
    
    //MARK: - Edit Button Is Tapped
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        let sheet = UIAlertController(title: "Choose Your Profile Photo", message: "", preferredStyle: .actionSheet)
        
        let fromLibrary = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let makePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }
        }
        
        let removePhoto = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
            self.profilePhoto.image = #imageLiteral(resourceName: "profilePhoto(e4e82b)-1")
            self.firstLetterName.isHidden = false
            self.firstLetterSurname.isHidden = false
            
        }
        
        let cancelEdition = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(fromLibrary)
        sheet.addAction(makePhoto)
        sheet.addAction(removePhoto)
        sheet.addAction(cancelEdition)
        present(sheet, animated: true, completion: nil)
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePhoto.image = image
            profilePhoto.contentMode = .scaleAspectFill
            firstLetterName.isHidden = true
            firstLetterSurname.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

