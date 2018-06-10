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
import FirebaseAuth

class MapViewController: UIViewController {

    var locationManager: CLLocationManager!
    var skateSpots = [SkateSpot]()
    var skateSpotsNewsFeed = [SkateSpot]()
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
    
    //Filter Tags
    @IBOutlet weak var filterRail: UIButton!
    @IBOutlet weak var filterStairs: UIButton!
    @IBOutlet weak var filterManual: UIButton!
    @IBOutlet weak var filterHubba: UIButton!
    @IBOutlet weak var filterGap: UIButton!
    
    
    let regionRadius: CLLocationDistance = 5000
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if DatabaseManager.isLoggedIn() == false
        {
            presentLoginController()
        }
        
       // DatabaseManager.signOut()
        
        setupUserProfile()
        setUpNavigationBar()
        setUpLocationManager()
        setUpTabButtons()
        setUpFilterOptionsView()
        getSpotsFromDatabase()

        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(popUpView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
                
        DatabaseManager.getUserName(userID: userID) { (username) in
            User.username = username
        }
        
        DatabaseManager.downloadProfileImage(userID: userID) { (image) in
            User.profileImage = image
        }

        DatabaseManager.getSpotFavourites { (favourites) in
            User.favouriteSpots = favourites
        }
        DatabaseManager.getParkFavourites { (favourites) in
            User.favouriteParks = favourites
        }
        DatabaseManager.getRatedSpots { (rated) in
            User.ratedSpots = rated
        }
    }
    
    func getSpotsFromDatabase()
    {
        DatabaseManager.getSkateSpots { (spots) in
            
            self.skateSpotsNewsFeed = spots.reversed()
            
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
        
        for spot in skateSpotsNewsFeed
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
            if spot.userID != nil {
               
                    DatabaseManager.downloadSpotProfileImage(userID: spot.userID, completion: { (image) in
                        spot.userProfileImage = image
                    })

            }

            
        }
        
    }
    
    func setUpFilterOptionsView()
    {
       for button in filterContainerView.subviews[0].subviews
       {
            button.layer.cornerRadius = button.frame.size.width / 2
        
            button.clipsToBounds = true
       }
        
//        filterContainerView.layer.shadowColor = UIColor.black.cgColor
//        filterContainerView.layer.shadowOpacity = 0.5
//        filterContainerView.layer.shadowOffset = CGSize.zero
//        filterContainerView.layer.shadowRadius = 15
//        filterContainerView.layer.borderWidth = 1
//        filterContainerView.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
    }
    
    @IBAction func filterMap() {
        var skateSpotsFiltered = [SkateSpot]()
        
        var tagsFiltered = [SkateSpot.SpotTag]()
        
        if filterGap.isSelected {
            tagsFiltered.append(.Gap)
        }
        if filterRail.isSelected {
            tagsFiltered.append(.Rail)
        }
        if filterHubba.isSelected {
            tagsFiltered.append(.Hubba)
        }
        if filterManual.isSelected {
            tagsFiltered.append(.Manual)
        }
        if filterStairs.isSelected {
            tagsFiltered.append(.Stairs)
        }
        
        for spot in skateSpots {
            guard let spotTags = spot.spotTags else { continue }
            for tag in spotTags {
                if tagsFiltered.contains(tag) {
                    skateSpotsFiltered.append(spot)
                    break
                }
            }
        }
        
        if tagsFiltered.count == 0 {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(skateSpots)
        }
        else {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(skateSpotsFiltered)
        }

        
    }
    

    
    
    @IBAction func selectFilterButtons(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            filterRail.isSelected = !sender.isSelected
            break
        case 1:
            filterStairs.isSelected = !sender.isSelected
            break
        case 2:
            filterManual.isSelected = !sender.isSelected
            break
        case 3:
            filterHubba.isSelected = !sender.isSelected
            break
        case 4:
            filterGap.isSelected = !sender.isSelected
            break
        default:
            break
        }
    }
    
    
    @IBAction func showFilterOptions(_ sender: UIButton)
    {
        if(sender.isSelected == false)
        {
            filterContainerView.center.y = view.bounds.height * 1.5
            filterContainerView.isHidden = false
            UIView.animate(withDuration: 0.5, delay:0, options: [], animations: {
                self.filterContainerView.center.y = self.view.bounds.height - (self.tabBarContainer.bounds.height + 38)
                self.filterButton.setImage(UIImage(named: "tagoptionsfilled"), for: .normal)
            }, completion: { (done) in
                sender.isSelected = true
            })
        }
        else
        {
            sender.isSelected = false
            self.filterButton.setImage(UIImage(named: "tagoptions"), for: .normal)
            self.filterContainerView.isHidden = true
        }
    }
    
    
    func setUpTabButtons()
    {
        tabBarContainer.layer.shadowColor = UIColor.black.cgColor
        tabBarContainer.layer.shadowOpacity = 0.5
        tabBarContainer.layer.shadowOffset = CGSize.zero
        tabBarContainer.layer.shadowRadius = 15
        
        let settingsImage = UIImage(named: "message")
        let tintedImage2 = settingsImage?.withRenderingMode(.alwaysTemplate)
        settingsButton.setImage(tintedImage2, for: .normal)
        settingsButton.tintColor = UIColor.lightGray
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.SpotKingColors.lightGreen, NSAttributedStringKey.font:UIFont(name: "Helvetica Neue", size: 24)!]
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
                        NetworkManager.getSpotDetails(spot: spot, placeID: spot.placeID!)
                        self.skateSpots.append(spot);
                        self.mapView.addAnnotation(spot)
                    }
            }
        }
        
        NetworkManager.getSkateSpot(location:(currentLocation?.coordinate)!,type:SkateSpot.SpotType.SkatePark) { (spots) in
            DispatchQueue.main.async()
                {
                    for spot in spots
                    {
                        NetworkManager.getSpotDetails(spot: spot, placeID: spot.placeID!)
                        if spot.spotImage == nil {
                            spot.spotImage = #imageLiteral(resourceName: "shop")
                        }
                        self.skateSpotsNewsFeed.append(spot)
                        self.skateSpots.append(spot);
                        self.mapView.addAnnotation(spot)
                    }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StorySegue" {
            if let storyVC = segue.destination as? StoryViewController {
                storyVC.skateSpots = self.skateSpotsNewsFeed
            }
        }
        
        if segue.identifier == "ProfileSegue" {
            if let profileVC = segue.destination as? ProfileViewController {
                profileVC.skateSpots = self.skateSpotsNewsFeed
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

