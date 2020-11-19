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
    weak var delegate: SaveAvatarPicture?
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorIsSet()
        loadPictures()
        delegates()
    }
    
    func activityIndicatorIsSet() {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    func loadPictures() {
        DispatchQueue.global(qos: .background).async {
            self.model?.loadPicturesURL()
        }
    }
    
    func delegates() {
        avatarCollectionView.dataSource = self
        avatarCollectionView.delegate = self
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        delegate?.ifCancelIsTapped()
    }
}

// MARK: - UICollectionViewDataSource

extension AvatarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.arrayOfPictures.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.Avatar.reuseCell, for: indexPath) as? AvatarViewCell
            else { return UICollectionViewCell() }
        cell.configure(with: UIImage(imageLiteralResourceName: "image-gallery"))
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let amount = model?.arrayOfPictures.count else { return }
        if indexPath.row == amount - 7 {
            DispatchQueue.global(qos: .background).async {
                self.model?.loadPicturesURL()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AvatarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = self.model?.arrayOfPictures[indexPath.row].webformatURL else { return }
            self.model?.loadPictures(url: url, completion: { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.delegate?.setProfile(image: image, url: url)
                    }
                }
            })
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AvatarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        return CGSize(width: width * 0.3, height: width * 0.3)
    }
}

// MARK: - AvatarDelegate

extension AvatarViewController: AvatarDelegate {
    func loadComplited() {
        DispatchQueue.main.async {
            self.avatarCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
