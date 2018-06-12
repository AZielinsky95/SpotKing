//
//  AddSpotViewController.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-01.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddSpotProtocol
{
    func addSpot(spot:SkateSpot)
}

class AddSpotViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var spotTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var spotDesc: UITextView!
    
    @IBOutlet weak var railTagButton: UIButton!
    @IBOutlet weak var stairsTagButton: UIButton!
    @IBOutlet weak var manualTagButton: UIButton!
    @IBOutlet weak var ledgeTagButton: UIButton!
    @IBOutlet weak var gapTagButton: UIButton!
    
    public var spotImage : UIImage?
    var locationManager: CLLocationManager!
    var currentLocation : CLLocation?
    var spotTags = [SkateSpot.SpotTag]()
    
    var delegate : AddSpotProtocol? 
    
    var imagePickedBlock: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        imageView.image = spotImage
        postButton.backgroundColor = UIColor.SpotKingColors.lightGreen
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.layer.cornerRadius = 5
        cancelButton.setTitleColor(UIColor.SpotKingColors.darkGreen, for: .normal)
        
        spotTitle.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        spotTitle.layer.borderWidth = 0.5
        spotDesc.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        spotDesc.layer.borderWidth = 0.5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        spotDesc.placeholder = "Description"
        
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.shadowColor = UIColor.black.cgColor
        cancelButton.layer.shadowOpacity = 0.25
        cancelButton.layer.shadowOffset = CGSize.zero
        cancelButton.layer.shadowRadius = 4
        cancelButton.layer.borderWidth = 3
        cancelButton.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        cancelButton.layer.cornerRadius =  cancelButton.frame.size.width / 2
    
       // railTagButton.layer.cornerRadius = 16
      //  stairsTagButton.layer.cornerRadius = 16
       // manualTagButton.layer.cornerRadius = 16
       // LedgeTagButton.layer.cornerRadius = 16
       // gapTagButton.layer.cornerRadius = 16
        
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true

        
//        railTagButton.layer.borderColor = UIColor.black.cgColor
//        stairsTagButton.layer.borderColor = UIColor.black.cgColor
//        manualTagButton.layer.borderColor = UIColor.black.cgColor
//        LedgeTagButton.layer.borderColor = UIColor.black.cgColor
//        gapTagButton.layer.borderColor = UIColor.black.cgColor
//        
//        railTagButton.layer.borderWidth = 1
//        stairsTagButton.layer.borderWidth = 1
//        manualTagButton.layer.borderWidth = 1
//        LedgeTagButton.layer.borderWidth = 1
//        gapTagButton.layer.borderWidth = 1
        
        spotTitle.delegate = self
    }
    
    func setUpLocationManager()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postSpot() {
        guard let spotTitle = self.spotTitle.text, let spotDescription = self.spotDesc.text,
        let currentLocation = self.currentLocation else { return }
        
        if railTagButton.isSelected
        {
            let type = SkateSpot.SpotTag.Rail
            spotTags.append(type)
        }
        if stairsTagButton.isSelected
        {
            let type = SkateSpot.SpotTag.Stairs
            spotTags.append(type)
        }
        if ledgeTagButton.isSelected
        {
            let type = SkateSpot.SpotTag.Ledge
            spotTags.append(type)
        }
        if gapTagButton.isSelected
        {
            let type = SkateSpot.SpotTag.Gap
            spotTags.append(type)
        }
        if manualTagButton.isSelected
        {
            let type = SkateSpot.SpotTag.Manual
            spotTags.append(type)
        }
        
        
        let spot = SkateSpot(userId: "", type: .SkateSpot, title: spotTitle, spotDescription: spotDescription, rating: nil, spotImage: self.imageView.image, coordinates: currentLocation.coordinate, imageURL: "",tags:spotTags, spotID: "", username: User.username, comments: [String:[String]]())
        
        //Save spot to database
        DatabaseManager.saveSkateSpot(spot: spot)
        
        
        //Send spot to MapVC
        delegate?.addSpot(spot: spot)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tagButtonTapped(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            if(!sender.isSelected)
            {
                sender.isSelected = true
                sender.layer.borderWidth = 3
                sender.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor;
            }
            else
            {
                sender.isSelected = false
                sender.layer.borderWidth = 0
            }
        }
        else if sender.tag == 2
        {
            if(!sender.isSelected)
            {
                sender.isSelected = true
                sender.layer.borderWidth = 3
                sender.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor;
            }
            else
            {
                sender.isSelected = false
                sender.layer.borderWidth = 0
            }
        }
        else if sender.tag == 3
        {
            if(!sender.isSelected)
            {
                sender.isSelected = true
                sender.layer.borderWidth = 3
                sender.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor;
            }
            else
            {
                sender.layer.borderWidth = 0
                sender.isSelected = false
            }
        }
        else if sender.tag == 4
        {
            if(!sender.isSelected)
            {
                sender.isSelected = true
                sender.layer.borderWidth = 3
                sender.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor;
            }
            else
            {
                sender.layer.borderWidth = 0
                sender.isSelected = false
            }
        }
        else if sender.tag == 5
        {
            if(!sender.isSelected)
            {
                sender.isSelected = true
                sender.layer.borderWidth = 3
                sender.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor;
            }
            else
            {
                sender.layer.borderWidth = 0
                sender.isSelected = false
            }
        }
    }
}

extension AddSpotViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddSpotViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if currentLocation == nil
        {
            currentLocation = locations.first!
        }
    }
}

extension UITextView : UITextViewDelegate {
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /* Updated for Swift 4 */
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}


