//
//  AddSpotViewController.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-01.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class AddSpotViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var spotTitle: UITextField!
    @IBOutlet weak var spotDescription: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePickedBlock: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(AddSpotViewController.imageSelectorTapped(recognizer:)))
        tapGesture.delegate = self
        imageView.addGestureRecognizer(tapGesture)
    }

    
    @objc func imageSelectorTapped(recognizer:UITapGestureRecognizer) {
        showActionSheet(vc: self)
    }
    

    @IBAction func postSpot() {
        
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
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

extension AddSpotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
         //   self.imagePickedBlock?(image)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


