//
//  DatabaseManager.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-05-31.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class DatabaseManager
{
    static var ref : DatabaseReference = {
        return Database.database().reference()
    }()
    
    static func handleRegister(username:String, email:String,password:String)
    {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil
            {
                print(error!.localizedDescription);
            }
            
            //successfully created a user!
            //TODO save user
            let values = ["name":username,"email":email]
            let userRef = ref.child("users")
            userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil
                {
                    print(err!.localizedDescription)
                    return
                }
                
                print("Saved user into Firebase DB");
            })
        }
    }
    
   static func saveSkateSpot(spot:SkateSpot)
    {
        let generatedRef = ref.child("skatespots").childByAutoId()
        
        generatedRef.observe(.value, with: { (snapshot) in
            
            let newSpot = [ // 2
                "userID": snapshot.childrenCount,
                "rating": spot.spotRating ?? 0,
                "spotType": spot.spotType.toString(),
                "lat": spot.coordinate.latitude,
                "lng": spot.coordinate.longitude,
                "title": spot.title!,
                "subTitle": spot.subtitle!,
                
                ] as [String : Any]
            
            generatedRef.setValue(newSpot);
            
        })
        
        
        
    }
    
    static func getSkateSpots(completion: @escaping ([SkateSpot])->()) {
        var skateSpots = [SkateSpot]()
        
        let spotRef = ref.child("skatespots")
        spotRef.observe(.value, with: { (snapshot) in
            
            for spot in snapshot.children {
                
                guard let spotSnapshot = spot as? DataSnapshot, let value = spotSnapshot.value as? NSDictionary else {
                    continue
                }
                
                let title = value["title"] as? String ?? ""
                let subtitle = value["subTitle"] as? String ?? ""
                let spotTypeStr = value["spotType"] as? String ?? ""
                let spotType = SkateSpot.SpotType.toSpotType(strSpotType: spotTypeStr)
                let coordinate = CLLocationCoordinate2DMake((value["lat"] as? Double)!, (value["lng"] as? Double)!)
                let spotRating = value["rating"] as? Double
                let userID = value["userID"] as? Int
                
                
                let skateSpot = SkateSpot(userId: userID!, type: spotType, title: title, subtitle: subtitle, rating: spotRating, pinImage: nil, coordinates: coordinate)

                
                skateSpots.append(skateSpot)
                
            }
            completion(skateSpots)
            
        })
        
        
    }
}
