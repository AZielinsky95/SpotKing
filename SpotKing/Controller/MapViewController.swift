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
    
    let regionRadius: CLLocationDistance = 2000
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpLocationManager()
    }
    
    func setUpNavigationBar()
    {
        let image = UIImage(named: "crown")
        let titleImageView = UIImageView(image: image)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
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

