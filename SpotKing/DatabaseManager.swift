//
//  DatabaseManager.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-05-31.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import CoreLocation

class DatabaseManager
{
    lazy var ref : DatabaseReference = {
        return Database.database().reference()
    }()
    
    func saveSkateSpot(spot:SkateSpot)
    {
        let generatedRef = ref.child("skatespots").childByAutoId()
        
       generatedRef.observe(.value, with: { (snapshot) in

          //  print(snapshot.value)
           // print(snapshot.childrenCount)
          //  guard let results = snapshot.value as? [String:Any] else { return }
            
     //       print(results.count)
//            for t in snapshot.children {
//                guard let taskSnapshot = t as? DataSnapshot else {
//                    continue
//                }
//
//                let id = taskSnapshot.key
//            }

        let newSpot = [ // 2
            "userID": snapshot.childrenCount,
            "rating": spot.spotRating,
            "spotType": spot.spotType.hashValue,
            "lat": spot.coordinate.latitude,
            "lng": spot.coordinate.longitude,
            "title": spot.title!,
            "subTitle": spot.subtitle!,
            
            ] as [String : Any]
        
            generatedRef.setValue(newSpot);
        
        })
        

        
    }
    
    func getSkateSpots(completion: @escaping ([SkateSpot])->()) {
        var skateSpots = [SkateSpot]()
        
        let spotRef = ref.child("skatespots")
        spotRef.observe(.value, with: { (snapshot) in
          
            for spot in snapshot.children {
                
                guard let spotSnapshot = spot as? DataSnapshot, let value = spotSnapshot.value as? NSDictionary else {
                    continue
                }
                
                let skateSpot = SkateSpot()
                skateSpot.title = value["title"] as? String ?? ""
                skateSpot.subtitle = value["subTitle"] as? String ?? ""
                skateSpot.spotType = value["spotType"] as? SkateSpot.SpotType
                skateSpot.coordinate = CLLocationCoordinate2DMake((value["lat"] as? Double)!, (value["lng"] as? Double)!)
                skateSpot.spotRating = value["rating"] as? Double
                skateSpot.userID = value["userID"] as? Int
                
                skateSpots.append(skateSpot)
                
            }
            completion(skateSpots)
            
        })
        
   
    }
}
