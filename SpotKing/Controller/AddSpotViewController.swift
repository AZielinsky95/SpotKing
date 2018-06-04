//
//  AddSpotViewController.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-01.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit
import CoreLocation

class AddSpotViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var spotTitle: UITextField!
    @IBOutlet weak var spotDescription: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    public var spotImage : UIImage?
    var locationManager: CLLocationManager!
    var currentLocation : CLLocation?
    
    
    var imagePickedBlock: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        imageView.image = spotImage
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

    @IBAction func postSpot() {
        guard let spotTitle = self.spotTitle.text, let spotDescription = self.spotDescription.text,
        let currentLocation = self.currentLocation else { return }
        
        let spot = SkateSpot(userId: "", type: .SkateSpot, title: spotTitle, subtitle: spotDescription, rating: nil, pinImage: self.imageView.image, coordinates: currentLocation.coordinate, imageURL: "")
       DatabaseManager.saveSkateSpot(spot: spot)
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


