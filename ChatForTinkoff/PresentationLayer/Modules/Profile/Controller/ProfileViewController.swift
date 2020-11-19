//
//  ProfileViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 13.09.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    var alertManager = AlertManager()
    
    var presentationAssembly: PresentationAssemblyProtocol?
    
    var switchLogs = SwitchLogs()
    var imagePicker = UIImagePickerController()
    var letterName: String = ""
    var letterSurname: String = ""
    var name: String? = "Marina Dudarenko"
    var text = "UX/UI designer, web-designer Moscow, Russia"
    
    var profileGCDModel: ProfileProtocol?
    var profileOperationModel: ProfileProtocol?
    
    var model: AvatarModelProtocol?
    
    var profileInfo: ProfileInfo?
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserversKeyboard()
        switchLogs.forProfileViewController(method: "\(#function)")
        editingProfile()
        profileNameAndAbout()
        delegates()
        changeTheme()
        activityIndicatorFunc()
        guard let profileGCD = profileGCDModel else { return }
        //        guard let profileOperation = profileOperationModel else { return }
        //        readDataFile(dataManager: profileOperationModel)
        readDataFile(dataManager: profileGCD)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchLogs.forProfileViewController(method: "\(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profilePhoto.layer.cornerRadius = profilePhoto.bounds.size.height / 2
        let fontProfileName = profilePhoto.bounds.size.height / 10
        let fontAboutYourself = profilePhoto.bounds.size.height / 15
        
        profileName.font = UIFont.systemFont(ofSize: fontProfileName, weight: .bold)
        aboutYourself.font = UIFont.systemFont(ofSize: fontAboutYourself, weight: .regular)
        
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
    
    func delegates() {
        nameTextField.delegate = self
        aboutTextField.delegate = self
        imagePicker.delegate = self
    }
    
    // MARK: - Read and Write Data Functions
    
    func readDataFile(dataManager: ProfileProtocol) {
        dataManager.readFile(file: dataManager.fileWithData()) { data in
            
            self.finishedEditing()
            
            if let data = data,
                let profileInfo = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ProfileInfo {
                
                self.profileInfo = profileInfo
                self.profileName.text = profileInfo.name
                self.aboutYourself.text = profileInfo.aboutYourself
                self.profilePhoto.image = profileInfo.profileImage
                self.labelsAreHidden(parameter1: self.firstLetterName, parameter2: self.firstLetterSurname, state: false)
                
                self.profileNameAndAbout()
            }
            
            if self.profilePhoto.image == nil {
                self.profilePhoto.image = UIImage(imageLiteralResourceName: "profilePhoto(e4e82b)-1")
            }
            if self.profilePhoto.image != UIImage(imageLiteralResourceName: "profilePhoto(e4e82b)-1") {
                self.profilePhoto.contentMode = .scaleAspectFill
            }
        }
    }
    
    func writeDataFile(dataManager: ProfileProtocol) {
        let textName = nameTextField.text ?? ""
        let textAboutYourself = aboutTextField.text ?? ""
        let image = profilePhoto.image ?? UIImage(imageLiteralResourceName: "profilePhoto(e4e82b)-1")
        
        let newProfile = ProfileInfo(name: textName, aboutYourself: textAboutYourself, profileImage: image)
        self.activityIndicator.startAnimating()
        
        do {
            let newData = try NSKeyedArchiver.archivedData(withRootObject: newProfile, requiringSecureCoding: false)
            
            buttonsAreEnable(state: false)
            
            dataManager.writeFile(file: dataManager.fileWithData(), data: newData) { completed in
                
                self.activityIndicator.stopAnimating()
                
                if completed {
                    self.profileInfo = newProfile
                    self.alertManager.editingSuccessfulAlert(title: "Editing was successful", message: "The changes are saved!") {
                        self.readDataFile(dataManager: dataManager)
                    }
                    
                } else {
                    self.alertManager.errorAlert(message: "Error", repeatedBlock: {
                        self.writeDataFile(dataManager: dataManager)
                    }, okBlock: {
                        self.buttonsAreHidden(parameter1: self.buttonGCD, parameter2: self.buttonOperation, state1: true, state2: true)
                        self.editButton.isHidden = false
                    })
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    // MARK: - Keyboard Functions
    
    func addObserversKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyBoard(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            guard let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            
            if notification.name == UIResponder.keyboardWillHideNotification {
                scrollView.contentInset = UIEdgeInsets.zero
            } else {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            }
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }
    
    // MARK: - Edit Profile Functions
    
    func profileNameAndAbout() {
        
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
    }
    
    func activityIndicatorFunc() {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        view.addSubview(activityIndicator)
    }
    
    func editingProfile() {
        
        aboutYourself.text = text
        profileName.text = name
        buttonsAreHidden(parameter1: buttonGCD, parameter2: buttonOperation, state1: true, state2: true)
        buttonsAreHidden(parameter1: editProfilePhotoButton, parameter2: editButton, state1: true, state2: false)
        
        editButton.layer.cornerRadius = editButton.bounds.size.height / 3
        
        editProfilePhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        buttonGCD.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        buttonOperation.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        firstLetterName.font = UIFont.systemFont(ofSize: 120, weight: .regular)
        firstLetterSurname.font = UIFont.systemFont(ofSize: 120, weight: .regular)
        
        profilePhoto.image = UIImage(imageLiteralResourceName: "profilePhoto(e4e82b)-1")
        
        buttonGCD.layer.cornerRadius = buttonGCD.bounds.size.height / 3
        buttonOperation.layer.cornerRadius = buttonOperation.bounds.size.height / 3
        
    }
    
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
    
    func labelsAreHidden(parameter1: UILabel, parameter2: UILabel, state: Bool) {
        parameter1.isHidden = state
        parameter2.isHidden = state
    }
    
    func textfiledsAreHidden(parameter1: UITextField, parameter2: UITextField, state: Bool) {
        parameter1.isHidden = state
        parameter2.isHidden = state
    }
    
    func buttonsAreHidden(parameter1: UIButton, parameter2: UIButton, state1: Bool, state2: Bool) {
        parameter1.isHidden = state1
        parameter2.isHidden = state2
    }
    
    func buttonsAreEnable(state: Bool) {
        buttonGCD.isEnabled = state
        buttonOperation.isEnabled = state
    }
    
    func finishedEditing() {
        buttonsAreHidden(parameter1: buttonGCD, parameter2: buttonOperation, state1: true, state2: true)
        buttonsAreHidden(parameter1: editProfilePhotoButton, parameter2: editButton, state1: true, state2: false)
        labelsAreHidden(parameter1: profileName, parameter2: aboutYourself, state: false)
        textfiledsAreHidden(parameter1: nameTextField, parameter2: aboutTextField, state: true)
    }
    
    // MARK: - Changing Theme
    
    func changeTheme() {
        navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme.backgroundColor
        navigationController?.navigationBar.tintColor = ThemeManager.currentTheme.textColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.textColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme.textColor]
        view.backgroundColor = ThemeManager.currentTheme.backgroundColor
        profileName.textColor = ThemeManager.currentTheme.myProfileTextColor
        aboutYourself.textColor = ThemeManager.currentTheme.myProfileTextColor
        editButton.backgroundColor = ThemeManager.currentTheme.myProfileSaveButton
    }
    
    // MARK: - Button Actions
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfilePhotoButtonTapped(_ sender: UIButton) {
        
        alertManager.actionSheetProfile(imagePicker: imagePicker, completionFromLibrary: {
            self.buttonsAreEnable(state: true)
        }, completionMakePhoto: {
            self.buttonsAreEnable(state: true)
        }, completionDownloadPhoto: {
            guard let avatarViewController = self.presentationAssembly?.avatarNavigationController() else { return }
            
            guard let avatarVC = self.presentationAssembly?.avatarViewController() else { return }
            avatarVC.delegate = self.presentationAssembly?.profileViewController()
            
            self.present(avatarViewController, animated: true)
        }, completionRemovePhoto: {
            self.profilePhoto.image = UIImage(imageLiteralResourceName: "profilePhoto(e4e82b)-1")
            self.labelsAreHidden(parameter1: self.firstLetterName, parameter2: self.firstLetterSurname, state: false)
            self.buttonsAreEnable(state: true)
        })
    }
    
    @IBAction func editButtonIsTapped(_ sender: UIButton) {
        
        buttonsAreEnable(state: false)
        labelsAreHidden(parameter1: profileName, parameter2: aboutYourself, state: true)
        buttonsAreHidden(parameter1: buttonGCD, parameter2: buttonOperation, state1: false, state2: false)
        buttonsAreHidden(parameter1: editButton, parameter2: editProfilePhotoButton, state1: true, state2: false)
        textfiledsAreHidden(parameter1: nameTextField, parameter2: aboutTextField, state: false)
        
        nameTextField.text = profileName.text
        aboutTextField.text = aboutYourself.text
    }
    
    @IBAction func buttonGCDIsTapped(_ sender: UIButton) {
        guard let profileGCD = profileGCDModel else { return }
        writeDataFile(dataManager: profileGCD)
    }
    
    @IBAction func buttonOperationIsTapped(_ sender: UIButton) {
        guard let profileOperation = profileOperationModel else { return }
        writeDataFile(dataManager: profileOperation)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePhoto.image = image
            profilePhoto.contentMode = .scaleAspectFill
            labelsAreHidden(parameter1: firstLetterName, parameter2: firstLetterSurname, state: true)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !activityIndicator.isAnimating {
            buttonsAreEnable(state: true)
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

extension ProfileViewController: SaveAvatarPicture {
    func setProfile(image: UIImage?, url: String) {
        print("Picture is set")
        print(url)
//        if let image = image {
//        profilePhoto.image = image
//        profileInfo?.profileImage = image
//        firstLetterName.isHidden = true
//        firstLetterSurname.isHidden = true
//        buttonsAreEnable(state: true)
//            self.loadViewIfNeeded()
//            guard let avatarVC = presentationAssembly?.avatarViewController() else { return }
//            avatarVC.dismiss(animated: true) {
//                print("Is changed")
//            }
        print("Picture is set")
    // }
//        else {
//            print("Nil")
//        }
    }
}
