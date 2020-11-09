//
//  ThemesViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 04.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBOutlet weak var classic: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var night: UILabel!
    @IBOutlet weak var classicImage: UIImageView!
    @IBOutlet weak var dayImage: UIImageView!
    @IBOutlet weak var nightImage: UIImageView!
    
    //Всякий раз, когда два объекта ссылаются друг на друга, один из них должен держать weak ссылку на другой, или произойдет retain cycle.
    
    weak var themesPickerDelegate: ThemesPickerDelegate?
    
    var themesClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classic.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        day.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        night.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeThemeOn(Theme.currentTheme)
        
    }
    
    @IBAction func dayButton(_ sender: UIButton) {
        changeThemeOn(.day)
  
    }
    
    @IBAction func classicButton(_ sender: UIButton) {
        changeThemeOn(.classic)
        
    }
    
    @IBAction func nightButton(_ sender: UIButton) {
        changeThemeOn(.night)
        
    }
    
    func changeThemeOn(_ theme: ThemeColors) {
    
        Theme.updateTheme(theme) {
            DispatchQueue.main.async {
                self.themesPickerDelegate?.changeTheme(self)
                self.navigationItemsTheme()
                self.changeOtherAttributesTheme(theme)
                self.themesClosure?()
            }
        }
    }
    
    func changeOtherAttributesTheme(_ theme: ThemeColors) {
        switch theme {
        case .classic:
            changeAttributesTheme(currentTheme: classicImage, anotherTheme1: dayImage, anotherTheme2: nightImage)
            
        case .day:
          changeAttributesTheme(currentTheme: dayImage, anotherTheme1: classicImage, anotherTheme2: nightImage)
            
        case .night:
       changeAttributesTheme(currentTheme: nightImage, anotherTheme1: dayImage, anotherTheme2: classicImage)
    
        }
    }
    
    func changeAttributesTheme(currentTheme: UIImageView, anotherTheme1: UIImageView, anotherTheme2: UIImageView) {
        currentTheme.layer.cornerRadius = Theme.currentTheme.cornerRadiusThemeButton
        currentTheme.layer.borderColor = Theme.currentTheme.borderColorThemeButton
        currentTheme.layer.borderWidth = Theme.currentTheme.borderWidthThemeButton
        currentTheme.clipsToBounds = Theme.currentTheme.clipsToBoundThemeButton
        anotherTheme1.layer.borderWidth = Theme.currentTheme.borderWidthThemeOtherButtons
        anotherTheme2.layer.borderWidth = Theme.currentTheme.borderWidthThemeOtherButtons
    }
    
    func navigationItemsTheme() {
        navigationController?.navigationBar.barTintColor = Theme.currentTheme.backgroundColor
        navigationController?.navigationBar.tintColor = Theme.currentTheme.textColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
        navigationController?.navigationBar.barStyle = Theme.currentTheme.barStyleColor
    }
}
