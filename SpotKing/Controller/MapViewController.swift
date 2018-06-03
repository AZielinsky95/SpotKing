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
        addButton.tintColor = UIColor.SpotKingColors.lightGreen
        
        let settingsImage = UIImage(named: "settings")
        let tintedImage2 = settingsImage?.withRenderingMode(.alwaysTemplate)
        settingsButton.setImage(tintedImage2, for: .normal)
        settingsButton.tintColor = UIColor.SpotKingColors.lightGreen
        
        let filterImage = UIImage(named: "more")
        let tintedImage3 = filterImage?.withRenderingMode(.alwaysTemplate)
        filterButton.setImage(tintedImage3, for: .normal)
        filterButton.tintColor = UIColor.SpotKingColors.lightGreen
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
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.glyphImage = annotation.pinImage
            view.markerTintColor = getPinAnnotationColor(type: annotation.spotType)
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

