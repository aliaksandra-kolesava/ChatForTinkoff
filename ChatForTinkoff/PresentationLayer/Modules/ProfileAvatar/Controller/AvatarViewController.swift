//
//  AvatarViewController.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 15.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {
    
    @IBOutlet weak var avatarCollectionView: UICollectionView!
    
    var model: AvatarModelProtocol?
    var sizeCell: CGFloat?
    var presentationAssembly: PresentationAssemblyProtocol?
    var delegate: SaveAvatarPicture?
//    weak var delegate: SaveAvatarPicture?
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            self.model?.loadPicturesURL()
        }
        
        avatarCollectionView.dataSource = self
        avatarCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension AvatarViewController: UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.arrayOfPictures.count ?? 0
            
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.Avatar.reuseCell, for: indexPath) as? AvatarViewCell
            else { return UICollectionViewCell() }
        cell.configure(with: UIImage(named: "profilePhoto(e4e82b)-1"))
        DispatchQueue.global(qos: .userInteractive).async {
            guard let pictureURL = self.model?.arrayOfPictures[indexPath.row].webformatURL else { return }
            self.model?.loadPictures(url: pictureURL, completion: { (image) in
                DispatchQueue.main.async {
                    cell.configure(with: image)
                    cell.layoutIfNeeded()
                }
            })
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == model?.arrayOfPictures.count ?? 7 - 7 {
//            model?.loadPicturesURL()
//           }
//       }
    
}

extension AvatarViewController: UICollectionViewDelegate {
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        model?.saveAvatarPicureDelegate = presentationAssembly?.profileViewController()
           DispatchQueue.global(qos: .userInteractive).async {
               guard let url = self.model?.arrayOfPictures[indexPath.row].webformatURL else { return }
               self.model?.loadPictures(url: url, completion: { (image) in
                guard let image = image else { return }
                   DispatchQueue.main.async {
//                    print("Second \(url)")
//                    self.delegate?.setProfile(image: image, url: url)
//                    self.model?.setChosenPhoto(image: image, url: url)
//                       self.delegate?.setProfile(image: picture)
                    self.dismiss(animated: true) {
//                        self.presentationAssembly?.profileViewController().profilePhoto.image = image
                        self.delegate?.setProfile(image: image, url: url)
                    }
                   }
               })
           }
       }
   }

//extension AvatarViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = view.frame.size.height
//        let width = view.frame.size.width
//        return CGSize(width: width, height: height)
//    }
//
//}

extension AvatarViewController: AvatarDelegate {
    func loadComplited() {
        DispatchQueue.main.async {
            self.avatarCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
