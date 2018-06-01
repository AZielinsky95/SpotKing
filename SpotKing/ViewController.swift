//
//  ViewController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-05-31.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let spot = SkateSpot();
//        spot.title = "testTi2tle"
//        spot.subtitle = "testSubTitle2"
//        spot.spotType =  SkateSpot.SpotType.SkatePark
//        spot.spotRating = 3.5;
//        spot.userID = 1
//        spot.coordinate = CLLocationCoordinate2D(latitude: -29, longitude: 40)
//        let db = DatabaseManager()
//        db.saveSkateSpot(spot: spot)
        
        let db = DatabaseManager()
        db.getSkateSpots { (skateSpots) in
            let spots = skateSpots
            var a = 4
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

