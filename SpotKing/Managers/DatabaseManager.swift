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
        
        let imageRef = Storage.storage().reference().child("spotImages").child("\(spotID)/\(randomFileName)")
       // guard let image = spot.pinImage, let imageData = UIImagePNGRepresentation(image) else {return }
        
        guard let currentUserID = Auth.auth().currentUser?.uid, let resizedImage = spot.spotImage?.resizeWith(percentage: 0.1), let resizedImageData = UIImagePNGRepresentation(resizedImage) else { return }
        
        imageRef.putData(resizedImageData, metadata: nil, completion: { (metadata, error) in
            if let error = error  {
                print(error.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                guard let url = url else { return }
                
                let date = Date.init()
                
                let newSpot = [
                    "userID": currentUserID,
                    "rating": spot.spotRating ?? 0,
                    "spotType": spot.spotType.toString(),
                    "lat": spot.coordinate.latitude,
                    "lng": spot.coordinate.longitude,
                    "title": spot.title!,
                    "description": spot.spotDescription!,
                    "imageURL": url.absoluteString,
                    "timestamp":date.timeIntervalSince1970,
                    "tags":spot.spotTagsToStringArray(),
                    "spotID":spotID
                    ] as [String : Any]
                
                generatedRef.setValue(newSpot);
            })
        })
    }
    
    static func getSkateSpots(completion: @escaping ([SkateSpot])->()) {
        var skateSpots = [SkateSpot]()
        
        let spotRef = ref.child("skatespots").queryOrdered(byChild: "timestamp")
        spotRef.observe(.value, with: { (snapshot) in
            
            for spot in snapshot.children {
                
                guard let spotSnapshot = spot as? DataSnapshot, let value = spotSnapshot.value as? NSDictionary else {
                    continue
                }
                
                let title = value["title"] as? String ?? ""
                let subtitle = value["description"] as? String ?? ""
                let spotTypeStr = value["spotType"] as? String ?? ""
                let spotType = SkateSpot.SpotType.toSpotType(strSpotType: spotTypeStr)
                let coordinate = CLLocationCoordinate2DMake((value["lat"] as? Double)!, (value["lng"] as? Double)!)
                let spotRating = value["rating"] as? Double
                let userID = value["userID"] as? String
                let imageURL = value["imageURL"] as? String
                let tagStrings = value["tags"] as? [String]
                var spotTags : [SkateSpot.SpotTag]?
                let spotID = value["spotID"] as? String
                if let tags = tagStrings
                {
                    for tag in tags
                    {
                        spotTags?.append(SkateSpot.SpotTag.toSpotTag(spotTagString: tag))
                    }
                }
                
                let skateSpot = SkateSpot(userId: userID!, type: spotType, title: title, spotDescription: subtitle, rating: spotRating, spotImage: nil, coordinates: coordinate, imageURL: imageURL!,tags: spotTags, spotID: spotID!)

                skateSpots.append(skateSpot)
                
            }
            completion(skateSpots)
            
        })
    }
    
    static func getUserName(userID: String, completion: @escaping (String)->()) {
        var username = ""
        
        let userRef = ref.child("users/\(userID)")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            username = value?["name"] as? String ?? ""
            completion(username)
        }
    }
    
    static func saveSpotFavourites(favourites:[String]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let favouriteSpotsRef = ref.child("users/\(currentUserID)/favouriteSpots")
        
        let favourites = ["spots": favourites] as [String : Any]
        favouriteSpotsRef.setValue(favourites)
    }
    
    static func getSpotFavourites(completion: @escaping ([String]) -> ()) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        var favouriteSpots = [String]()
        let favouriteSpotsRef = ref.child("users/\(currentUserID)/favouriteSpots")
        
        favouriteSpotsRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                favouriteSpots = (value!["spots"] as? [String]) ?? [String]()
            }
            
            completion(favouriteSpots)
        }
        
    }
    
    static func downloadSkateSpotImage(url: String, completion: @escaping (UIImage) -> Void ) {
        let configuration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: configuration)
        guard let imageURL = URL(string: url) else { return }
        
        let downloadTask: URLSessionDownloadTask = session.downloadTask(with: imageURL) { (url, response, error)  in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)!
            completion(image)
        }
        
        downloadTask.resume()
    }
}

extension UIImage {
    
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
}
}
