//
//  DatabaseManager.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-05-31.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager
{
    static var ref : DatabaseReference = {
        return Database.database().reference()
    }()
    
    static func saveSkateSpot(spot:SkateSpot)
    {
        let generatedRef = ref.child("skatespots").childByAutoId()
        
        generatedRef.observe(.value, with: { (snapshot) in

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
