//
//  ProfileViewController.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-06.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(recognizer:)))
        tapGesture.delegate = self
        self.imageView.addGestureRecognizer(tapGesture)
        
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
                    self.imageView.image = image
                    
                }
        }
        else
        {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
