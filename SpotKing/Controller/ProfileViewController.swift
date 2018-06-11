//
//  ProfileViewController.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-06.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var profileReusableView: ProfileReusableView?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var skateSpots : [SkateSpot]?
    
    var favouriteSpotsImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.title = "Profile"
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "map"), style: .plain, target: self, action: #selector(BackToMap))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(LogOut))
        setupFavouriteSpotImages()
    }
    
    @objc func BackToMap()
    {
      self.navigationController?.popViewController(animated: true)
    }
    
    @objc func LogOut()
    {
        DatabaseManager.signOut()
        self.navigationController?.popViewController(animated: true)
    //    presentLoginViewController()
    }
    
    func setUpProfileView()
    {
        profileReusableView!.imageView.layer.cornerRadius = profileReusableView!.imageView.frame.size.width / 2
        profileReusableView!.imageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(recognizer:)))
        tapGesture.delegate = self
        profileReusableView!.imageView.addGestureRecognizer(tapGesture)
        profileReusableView!.imageView.image = User.profileImage
        profileReusableView!.username.text = User.username
    }
    
    func setupFavouriteSpotImages() {
        guard let skateSpots = skateSpots else { return }
        
        for spot in skateSpots  {
            if User.favouriteSpots.contains(spot.spotID) || User.favouriteParks.contains(spot.spotID) {
                guard let image = spot.spotImage else { continue }
                favouriteSpotsImages.append(image)
            }
        }
    }
    
    @objc func imageViewTapped(recognizer : UITapGestureRecognizer) {
        showActionSheet(vc: self)
    }
    
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.allowsEditing = true
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: UIViewController) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension ProfileViewController : UIGestureRecognizerDelegate {
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            User.profileImage = image
            DatabaseManager.saveProfileImage(image: image)
            
            DispatchQueue.main.async
                {
                    self.profileReusableView?.imageView.image = image
                }
        }
        else
        {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteSpotsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            self.profileReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for:indexPath) as? ProfileReusableView

            setUpProfileView()
            
            return self.profileReusableView!
        }
        
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
       
        cell.imageView.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        cell.imageView.layer.borderWidth = 3
        cell.imageView.layer.cornerRadius = 16
        cell.imageView.layer.masksToBounds = true
        cell.imageView.image = favouriteSpotsImages[indexPath.row]
        
        return cell
        
    }
}
