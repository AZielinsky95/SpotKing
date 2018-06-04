//
//  ViewController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-05-31.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    var locationManager: CLLocationManager!
    var skateSpots = [SkateSpot]()
    var currentLocation : CLLocation?
    

    @IBOutlet weak var mapView: MKMapView!
    
    //Tab Bar Buttons
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    let regionRadius: CLLocationDistance = 2000
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if DatabaseManager.isLoggedIn() == false
        {
            presentLoginController()
        }
        
       // DatabaseManager.signOut()
        setUpNavigationBar()
        setUpLocationManager()
        setUpTabButtons()
    }
    
    func setUpTabButtons()
    {
        let addImage = UIImage(named: "add")
        let tintedImage = addImage?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(tintedImage, for: .normal)
        addButton.tintColor = UIColor.lightGray
        
        let settingsImage = UIImage(named: "settings")
        let tintedImage2 = settingsImage?.withRenderingMode(.alwaysTemplate)
        settingsButton.setImage(tintedImage2, for: .normal)
        settingsButton.tintColor = UIColor.lightGray
        
        let filterImage = UIImage(named: "more")
        let tintedImage3 = filterImage?.withRenderingMode(.alwaysTemplate)
        filterButton.setImage(tintedImage3, for: .normal)
        filterButton.tintColor = UIColor.lightGray
    }
    
    @IBAction func addSpotTapped(_ sender: UIButton)
    {
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
    
    func presentLoginController()
    {
        let loginController = LoginViewController()
        present(loginController,animated: true, completion: nil)
    }
    
    func setUpNavigationBar()
    {
        self.navigationItem.title = "Spot King"
        self.navigationController?.navigationBar.tintColor = UIColor.SpotKingColors.lightGreen
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.SpotKingColors.lightGreen, NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 26)]
//        let image = UIImage(named: "crown")
//        let titleImageView = UIImageView(image: image)
//        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        titleImageView.contentMode = .scaleAspectFit
//        self.navigationItem.titleView = titleImageView
    }
    
    func centerMapOnLocation(location:CLLocationCoordinate2D)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        getSkateShopAndParkData()
    }
    
    func setUpLocationManager()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.stopUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    func getSkateShopAndParkData()
    {
        NetworkManager.getSkateSpot(location:(currentLocation?.coordinate)!,type:SkateSpot.SpotType.SkateShop) { (spots) in
            DispatchQueue.main.async()
                {
                    for spot in spots
                    {
                        self.skateSpots.append(spot as! SkateSpot);
                        self.mapView.addAnnotation(spot)
                    }
            }
        }
        
        NetworkManager.getSkateSpot(location:(currentLocation?.coordinate)!,type:SkateSpot.SpotType.SkatePark) { (spots) in
            DispatchQueue.main.async()
                {
                    for spot in spots
                    {
                        self.skateSpots.append(spot as! SkateSpot);
                        self.mapView.addAnnotation(spot)
                    }
            }
        }
    }
}

extension MapViewController : AddSpotProtocol
{
    func addSpot(spot: SkateSpot) {
        self.skateSpots.append(spot);
        self.mapView.addAnnotation(spot)
        print("New Spot Added!")
    }
}

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DispatchQueue.main.async
            {
                print("GO TO SPOT VC")
                let addSpotController = self.storyboard?.instantiateViewController(withIdentifier: "addSpotVC") as! AddSpotViewController
                addSpotController.spotImage = image
                addSpotController.delegate = self;
                self.present(addSpotController,animated: true, completion: nil)
            }
        }
        else
        {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MapViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if currentLocation == nil
        {
            currentLocation = locations.first!
            self.mapView.showsUserLocation = true;
            centerMapOnLocation(location: (currentLocation?.coordinate)!)
        }
    }
}

extension MapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let annotation = annotation as? SkateSpot else { return nil }
        
        let identifier = "marker"
        
        var view:MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        {
            dequeuedView.annotation = annotation    
            view = dequeuedView
        }
        else
        {
            let (pinImage,pinColor) = annotation.pinImageAndColor
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.glyphImage = pinImage
            view.markerTintColor = pinColor
            view.animatesWhenAdded = true;
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5,y:5)
            view.leftCalloutAccessoryView = UIButton(type: .infoLight)
        }
        
        return view;
    }
    
    private func getPinAnnotationColor(type:SkateSpot.SpotType) -> UIColor
    {
        switch type
        {
            case .SkateSpot:
                return UIColor.green
            case .SkateShop:
                return UIColor.red
            case .SkatePark:
                return UIColor.magenta
        }
    }
}

