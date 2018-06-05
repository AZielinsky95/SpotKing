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
    
    public var spotImage : UIImage?
    var locationManager: CLLocationManager!
    var currentLocation : CLLocation?
    
    var delegate : AddSpotProtocol? 
    
    var imagePickedBlock: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        imageView.image = spotImage
        postButton.backgroundColor = UIColor.SpotKingColors.lightGreen
        postButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.SpotKingColors.darkGreen, for: .normal)
        
        spotTitle.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        spotTitle.layer.borderWidth = 0.5
        spotDesc.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        spotDesc.layer.borderWidth = 0.5
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        spotDesc.placeholder = "Description"
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
        
        let spot = SkateSpot(userId: "", type: .SkateSpot, title: spotTitle, subtitle: spotDescription, rating: nil, spotImage: self.imageView.image, coordinates: currentLocation.coordinate, imageURL: "")
        
        //Save spot to database
        DatabaseManager.saveSkateSpot(spot: spot)
        
        
        //Send spot to MapVC
        delegate?.addSpot(spot: spot)
        dismiss(animated: true, completion: nil)
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


