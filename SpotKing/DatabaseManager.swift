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

class DatabaseManager
{
    lazy var ref : DatabaseReference = {
        return Database.database().reference()
    }()
    
    func saveSkateSpot(spot:SkateSpot)
    {
        let generatedRef = ref.child("skatespots")
        
        generatedRef.observe(.value, with: { (snapshot) in

          //  print(snapshot.value)
            print(snapshot.childrenCount)
          //  guard let results = snapshot.value as? [String:Any] else { return }
            
     //       print(results.count)
            for t in snapshot.children {
                guard let taskSnapshot = t as? DataSnapshot else {
                    continue
                }

                let id = taskSnapshot.key
            }
            let newSpot = [ // 2
                "userID": spot.userID,
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
}
