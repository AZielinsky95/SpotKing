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
    
    @IBOutlet weak var filterContainerView: UIView!
    
    let popUpView : PopUpView =
    {
      let view = PopUpView(frame: CGRect(x: 0, y:-500, width: 275, height: 50), text: "New Spot Added!", image: #imageLiteral(resourceName: "crownicon"))
        
      return view
    }()

    @IBOutlet weak var mapView: MKMapView!
    
    //Tab Bar Buttons
    @IBOutlet weak var tabBarContainer: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    let regionRadius: CLLocationDistance = 5000
    
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
        getSpotsFromDatabase()
        
        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(popUpView)
    }
    
    func getSpotsFromDatabase()
    {
        DatabaseManager.getSkateSpots { (spots) in
            
            for spot in spots
            {
               self.skateSpots.append(spot)
               self.mapView.addAnnotation(spot)
            }
            
            self.downloadImagesForSkateSpots()
        }
    }
    
    func downloadImagesForSkateSpots()
    {
        for spot in skateSpots
        {
            if let url = spot.imageURL
            {
                DatabaseManager.downloadSkateSpotImage(url: url, completion: { (image) in
                    spot.spotImage = image
                })
            }
            else
            {
                //Placeholder
                spot.spotImage = #imageLiteral(resourceName: "shop")
            }
        }
    }
    
    @IBAction func showFilterOptions(_ sender: UIButton)
    {
     filterContainerView.isHidden = false
    }
    
    
    func setUpTabButtons()
    {
        tabBarContainer.layer.shadowColor = UIColor.SpotKingColors.lightGreen.cgColor
        tabBarContainer.layer.shadowOpacity = 0.5
        tabBarContainer.layer.shadowOffset = CGSize.zero
        tabBarContainer.layer.shadowRadius = 15
        
        let settingsImage = UIImage(named: "message")
        let tintedImage2 = settingsImage?.withRenderingMode(.alwaysTemplate)
        settingsButton.setImage(tintedImage2, for: .normal)
        settingsButton.tintColor = UIColor.lightGray
        
//        let filterImage = UIImage(named: "more")
//        let tintedImage3 = filterImage?.withRenderingMode(.alwaysTemplate)
//        filterButton.setImage(tintedImage3, for: .normal)
//        filterButton.tintColor = UIColor.lightGray
    }
    
    func showPopUpView()
    {
        popUpView.center.x = view.center.x
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.popUpView.center.y = self.popUpView.bounds.height * 2
        }, completion: { (done) in
        
            UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
               self.popUpView.center.y = -500
            })
        })
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
       // self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Pacific Again", size: 20)!]
        self.navigationItem.title = "Spot King"
        self.navigationController?.navigationBar.tintColor = UIColor.SpotKingColors.lightGreen
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.SpotKingColors.lightGreen, NSAttributedStringKey.font:UIFont(name: "Infinity", size: 32)!]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StorySegue" {
            if let storyVC = segue.destination as? StoryViewController {
                storyVC.skateSpots = self.skateSpots.reversed()
            }
        }
    }
}

extension MapViewController : AddSpotProtocol
{
    func addSpot(spot: SkateSpot) {
        self.skateSpots.append(spot);
        self.mapView.addAnnotation(spot)
        showPopUpView()
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
            view.animatesWhenAdded = true
            view.canShowCallout = true
            view.isEnabled = true
            view.calloutOffset = CGPoint(x: -5,y:5)

            view.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        
        return view;
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        guard let annotation = view.annotation as? SkateSpot else { return }
        
        print("annotation tapped")
        let temp = UIImageView(frame: CGRect(x: 2, y: 0, width: 75, height: 75))
        temp.image = annotation.spotImage
        temp.contentMode = .scaleAspectFill
        view.leftCalloutAccessoryView = temp;
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: 75, height: 30))
        subtitleLabel.text = annotation.ratingToStars()
        view.detailCalloutAccessoryView = subtitleLabel;
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        guard let annotation = view.annotation as? SkateSpot else { return }
        //segue to detail view
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        detailViewController.spot = annotation
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

