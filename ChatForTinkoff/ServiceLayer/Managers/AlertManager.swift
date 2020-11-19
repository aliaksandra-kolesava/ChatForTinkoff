//
//  Alerts.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 11.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    
    func actionSheetProfile(imagePicker: UIImagePickerController,
                            completionFromLibrary: @escaping () -> Void,
                            completionMakePhoto: @escaping () -> Void,
                            completionDownloadPhoto: @escaping () -> Void,
                            completionRemovePhoto: @escaping () -> Void) {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let sheet = UIAlertController(title: "Choose Your Profile Photo", message: "", preferredStyle: .actionSheet)
        
        let fromLibrary = UIAlertAction(title: "Choose Photo", style: .default) { (_) in
            imagePicker.sourceType = .photoLibrary
            if var controller = keyWindow?.rootViewController {
                while let presentedViewController = controller.presentedViewController {
                    controller = presentedViewController
                }
                controller.present(imagePicker, animated: true, completion: nil)
            }
            completionFromLibrary()
        }
        
        let makePhoto = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                if var controller = keyWindow?.rootViewController {
                    while let presentedViewController = controller.presentedViewController {
                        controller = presentedViewController
                    }
                    controller.present(imagePicker, animated: true, completion: nil)
                }
                completionMakePhoto()
            } else {
                print("Camera is not available")
            }
        }
        
        let downloadPhoto = UIAlertAction(title: "Download Photo", style: .default) { (_) in
            completionDownloadPhoto()
//            if var controller = keyWindow?.rootViewController {
//                while let presentedViewController = controller.presentedViewController {
//                    controller = presentedViewController
//                }
//                controller.present(controller, animated: true, completion: nil)
//            }
        }
        
        let removePhoto = UIAlertAction(title: "Remove Photo", style: .destructive) { (_) in
            completionRemovePhoto()
        }
        
        let cancelEdition = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(fromLibrary)
        sheet.addAction(makePhoto)
        sheet.addAction(downloadPhoto)
        sheet.addAction(removePhoto)
        sheet.addAction(cancelEdition)
        
        if var controller = keyWindow?.rootViewController {
            while let presentedViewController = controller.presentedViewController {
                controller = presentedViewController
            }
            controller.present(sheet, animated: true, completion: nil)
        }
    }
    
    func errorAlert(message: String, repeatedBlock: @escaping (() -> Void), okBlock: @escaping (() -> Void)) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okBlock()
        }
        
        alert.addAction(okAction)
        
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            repeatedBlock()
        }
        alert.addAction(repeatAction)
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var controller = keyWindow?.rootViewController {
            while let presentedViewController = controller.presentedViewController {
                controller = presentedViewController
            }
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func editingSuccessfulAlert(title: String = "", message: String, okBlock: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in okBlock()
        }
        alert.addAction(okAction)
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var controller = keyWindow?.rootViewController {
            while let presentedViewController = controller.presentedViewController {
                controller = presentedViewController
            }
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func addChannelAlert(completion: @escaping ((String) -> Void)) {
        DispatchQueue.main.async {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add New Channel", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (_) in
                if let chName = textField.text {
                    completion(chName)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new channel"
                textField = alertTextField
            }
            
            alert.addAction(cancel)
            alert.addAction(action)
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if var controller = keyWindow?.rootViewController {
                while let presentingViewController = controller.presentingViewController {
                    controller = presentingViewController
                }
                controller.present(alert, animated: true, completion: nil)
            }
        }
    }
}
