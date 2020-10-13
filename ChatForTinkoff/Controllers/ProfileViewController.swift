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
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editProfilePhotoButton: UIButton!
    @IBOutlet weak var firstLetterName: UILabel!
    @IBOutlet weak var firstLetterSurname: UILabel!
    @IBOutlet weak var buttonGCD: UIButton!
    @IBOutlet weak var buttonOperation: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextField!
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var switchLogs = SwitchLogs()
    var imagePicker = UIImagePickerController()
    var letterName: String = ""
    var letterSurname: String = ""
    var name: String? = "Marina Dudarenko"
    var text = "UX/UI designer, web-designer Moscow, Russia"
    
    var gcdDataManager = GCDDataManager()
    var profileInfo: ProfileInfo? = nil
    
    var activeField: UITextField?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //print(editButton.frame)
        //кнопка еще не инициализирована, поэтому ее значение frame = nil
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        print(filePath)

        switchLogs.forProfileViewController(method: "\(#function)")
        editingProfile()
        profileName.text = name
        
        if profileName.text != nil && profileName.text != "" {
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
        
        nameTextField.delegate = self
        aboutTextField.delegate = self
        
//        print(editButton.frame)
        imagePicker.delegate = self
        changeTheme()
        
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
              activityIndicator.center = view.center
              activityIndicator.hidesWhenStopped = true
              activityIndicator.style =
                  UIActivityIndicatorView.Style.whiteLarge
              view.addSubview(activityIndicator)
        
        readDataFile(dataManager: gcdDataManager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(editButton.frame)
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

    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func readDataFile(dataManager: DataManager) {
        dataManager.readFile(file: Files.files.fileWithData) {
            data in
            
            self.finishedEditing()

            if let data = data,
                let profileInfo = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ProfileInfo {

                self.profileInfo = profileInfo
                self.profileName.text = profileInfo.name
                self.aboutYourself.text = profileInfo.aboutYourself
                self.profilePhoto.image = profileInfo.profileImage
                self.firstLetterName.isHidden = false
                self.firstLetterSurname.isHidden = false
                
                if self.profileName.text != nil && self.profileName.text != "" {
                    self.firstLetterName.text = self.initialsName(name: self.profileName.text ?? "")

                    if self.initialsSurname(name: self.profileName.text ?? "") != "" {
                        self.firstLetterSurname.text = self.initialsSurname(name: self.profileName.text ?? "")
                       } else {
                        self.firstLetterSurname.isHidden = true
                       }
                       } else {
                    self.firstLetterName.text = ""
                    self.firstLetterSurname.text = ""
                       }
//                print(profileInfo.name)
                
            }
            
            if self.profilePhoto.image == nil {
                self.profilePhoto.image = #imageLiteral(resourceName: "profilePhoto(e4e82b)-1")
            }
            if self.profilePhoto.image != #imageLiteral(resourceName: "profilePhoto(e4e82b)-1") {
                self.profilePhoto.contentMode = .scaleAspectFill
//                self.firstLetterName.isHidden = true
//                self.firstLetterSurname.isHidden = true
            }
        }
        
    }
    
    func writeDataFile(dataManager: DataManager) {
        let textName = nameTextField.text ?? ""
        let textAboutYourself = aboutTextField.text ?? ""
        let image = profilePhoto.image ?? #imageLiteral(resourceName: "profilePhoto(e4e82b)-1")
        
        let newProfile = ProfileInfo(name: textName, aboutYourself: textAboutYourself, profileImage: image)
        
        do {
            let newData = try NSKeyedArchiver.archivedData(withRootObject: newProfile, requiringSecureCoding: false)
            
            self.activityIndicator.startAnimating()
            buttonGCD.isEnabled = false
            buttonOperation.isEnabled = false
            
            dataManager.writeFile(file: Files.files.fileWithData, data: newData){
                            completed in
                
                self.activityIndicator.stopAnimating()
                            
                            if completed {
                                self.profileInfo = newProfile
                                self.showCompletedAlert(title: "Editing was successful",
                                                        message: "The changes are saved!") {
                                                            self.readDataFile(dataManager: dataManager)
                                }

                            } else{
                                self.showErrorAlert(message: "Error", repeatedBlock: {
                                    self.writeDataFile(dataManager: dataManager)
                                }, okBlock: {
                                    self.editButton.isHidden = false
                                    self.buttonGCD.isHidden = true
                                    self.buttonOperation.isHidden = true
                                })
                            }
                        }
        } catch {
            print(error)
        }
        
    }
    
    func finishedEditing(){
        editButton.isHidden = false
        buttonGCD.isHidden = true
        buttonOperation.isHidden = true
        
        nameTextField.isHidden = true
        profileName.isHidden = false
        
//        editButton.isHidden = true
        aboutYourself.isHidden = false
        aboutTextField.isHidden = true
    }
    
    
    //MARK: - The Initial Edition Profile
    
    func editingProfile() {
        buttonGCD.isHidden = true
        buttonOperation.isHidden = true
        editProfilePhotoButton.isHidden = true
        
        profilePhoto.layer.cornerRadius = profilePhoto.bounds.size.width / 2
        editButton.layer.cornerRadius = editButton.bounds.size.height / 3
        
        profileName.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        editProfilePhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        buttonGCD.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        buttonOperation.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        aboutYourself.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        firstLetterName.font = UIFont.systemFont(ofSize: 120, weight: .regular)
        firstLetterSurname.font = UIFont.systemFont(ofSize: 120, weight: .regular)
        
        profilePhoto.image = #imageLiteral(resourceName: "profilePhoto(e4e82b)-1")
        
        buttonGCD.layer.cornerRadius = buttonGCD.bounds.size.height / 3
        buttonOperation.layer.cornerRadius = buttonOperation.bounds.size.height / 3
        
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
    
    
    //MARK: - Edit Profile Photo Button Is Tapped
    
    @IBAction func editProfilePhotoButtonTapped(_ sender: UIButton) {
        let sheet = UIAlertController(title: "Choose Your Profile Photo", message: "", preferredStyle: .actionSheet)
        
        let fromLibrary = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            self.buttonGCD.isEnabled = true
            self.buttonOperation.isEnabled = true
        }
        
        let makePhoto = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
                self.buttonGCD.isEnabled = true
                self.buttonOperation.isEnabled = true
            } else {
                print("Camera is not available")
            }
        }
        
        let removePhoto = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
            self.profilePhoto.image = #imageLiteral(resourceName: "profilePhoto(e4e82b)-1")
            self.firstLetterName.isHidden = false
            self.firstLetterSurname.isHidden = false
            self.buttonGCD.isEnabled = true
            self.buttonOperation.isEnabled = true
            
        }
        
        let cancelEdition = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(fromLibrary)
        sheet.addAction(makePhoto)
        sheet.addAction(removePhoto)
        sheet.addAction(cancelEdition)
        present(sheet, animated: true, completion: nil)
    }
    
    //MARK: - Changing Theme
    
    func changeTheme() {
         navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
         navigationController?.navigationBar.tintColor = Theme.currentTheme.textColor
         navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
        view.backgroundColor = Theme.currentTheme.backgroundColor
        profileName.textColor = Theme.currentTheme.myProfileTextColor
        aboutYourself.textColor = Theme.currentTheme.myProfileTextColor
        editButton.backgroundColor = Theme.currentTheme.myProfileSaveButton
        
     }
    
    //MARK: - Edit Button Is Tapped
    
    @IBAction func editButtonIsTapped(_ sender: UIButton) {
        
        buttonGCD.isEnabled = false
        buttonOperation.isEnabled = false
        
        editButton.isHidden = true
        editProfilePhotoButton.isHidden = false
        buttonGCD.isHidden = false
        buttonOperation.isHidden = false
        
        nameTextField.isHidden = false
        profileName.isHidden = true
        nameTextField.text = profileName.text
        
        editProfilePhotoButton.isHidden = false
        
        aboutYourself.isHidden = true
        aboutTextField.isHidden = false
        aboutTextField.text = aboutYourself.text
    }
    
    @IBAction func buttonGCDIsTapped(_ sender: UIButton) {
        writeDataFile(dataManager: gcdDataManager)
    }
    
    @IBAction func buttonOperationIsTapped(_ sender: UIButton) {
    }
    
    //MARK: - Alert Functions
    
    func showErrorAlert(message: String,  repeatedBlock: @escaping (() -> Void), okBlock: @escaping (() -> Void)) {
           let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
           
           let okAction = UIAlertAction(title: "OK", style: .default) { action in
               okBlock()
           }
           
           alert.addAction(okAction)
           
           let repeateAction = UIAlertAction(title: "Повторить", style: .default) { action in
               repeatedBlock()
           }
           alert.addAction(repeateAction)
           
           self.present(alert, animated: true, completion: nil)
       }
       
       func showCompletedAlert(title: String = "", message: String, okBlock: @escaping (() -> Void)) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default) {
               action in okBlock()
           }
           alert.addAction(okAction)
           
           self.present(alert, animated: true, completion: nil)
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

//MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
           return true
       }
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           if !activityIndicator.isAnimating {
            buttonGCD.isEnabled = true
            buttonOperation.isEnabled = true
           }
        
           return true
       }
       
       func textFieldDidBeginEditing(_ textField: UITextField) {
           activeField = textField
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           activeField = nil
       }
}


