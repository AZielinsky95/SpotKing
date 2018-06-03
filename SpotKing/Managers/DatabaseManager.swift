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
import FirebaseAuth
import FirebaseStorage

class DatabaseManager
{
    static var ref : DatabaseReference = {
        return Database.database().reference()
    }()
    
    static func isLoggedIn() -> Bool
    {
        return Auth.auth().currentUser?.uid == nil ? false : true
    }
    
    static func signOut()
    {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        
        //Make sure to present login VC when calling this method
    }
    
    static func handleLogin(email:String,password:String, completion: @escaping () -> Void)
    {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil
            {
                print(error!.localizedDescription);
                return
            }
            
            completion()
        }
    }
    
    static func handleRegister(username:String, email:String,password:String, completion: @escaping () -> Void )
    {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil
            {
                print(error!.localizedDescription);
            }
            
            //successfully created a user!
            //TODO save user
            
            guard let uid = result?.user.uid else
            {
                return
            }
            
            let values = ["name":username,"email":email]
            let userRef = ref.child("users").child(uid)
            
            userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil
                {
                    print(err!.localizedDescription)
                    return
                }
                
                print("Saved user into Firebase DB");
                completion()
            })
        }
    }
    
    static func saveSkateSpot(spot:SkateSpot)
    {
        let generatedRef = ref.child("skatespots").childByAutoId()
        let spotID = generatedRef.key
        let randomFileName = "\(UUID().uuidString).png"
        
        let imageRef = Storage.storage().reference().child("images").child("\(spotID)/\(randomFileName)")
        guard let image = spot.pinImage, let imageData = UIImagePNGRepresentation(image) else {return }
        
        
        imageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if let error = error  {
                print(error.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                guard let url = url else { return }
                
                let newSpot = [
                    "userID": generatedRef.key,
                    "rating": spot.spotRating ?? 0,
                    "spotType": spot.spotType.toString(),
                    "lat": spot.coordinate.latitude,
                    "lng": spot.coordinate.longitude,
                    "title": spot.title!,
                    "subTitle": spot.subtitle!,
                    "imageURL": url.absoluteString
                    
                    ] as [String : Any]
                
                generatedRef.setValue(newSpot);
            })
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
