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
        let spot = SkateSpot();
        spot.title = "testTitle"
        spot.subtitle = "testSubTitle"
        spot.spotType =  SkateSpot.SpotType.SkatePark
        spot.spotRating = 3.5;
        spot.userID = 1
        spot.coordinate = CLLocationCoordinate2D(latitude: -69, longitude: 70)
        let db = DatabaseManager()
        db.saveSkateSpot(spot: spot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

