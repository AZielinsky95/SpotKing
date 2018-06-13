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
    
    static var currentUserId : String =
    {
        return Auth.auth().currentUser!.uid
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
                    "rating": spot.spotRatingData ?? ["total": 0, "count": 0],
                    "spotType": spot.spotType.toString(),
                    "lat": spot.coordinate.latitude,
                    "lng": spot.coordinate.longitude,
                    "title": spot.title!,
                    "description": spot.spotDescription!,
                    "imageURL": url.absoluteString,
                    "timestamp":date.timeIntervalSince1970,
                    "tags":spot.spotTagsToStringArray(),
                    "spotID":spotID,
                    "username":spot.username
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
                let spotRating = value["rating"] as? [String:Int]
                let userID = value["userID"] as? String
                let imageURL = value["imageURL"] as? String
                let tagStrings = value["tags"] as? [String]
                var spotTags = [SkateSpot.SpotTag]()
                let spotID = value["spotID"] as? String
                let username = value["username"] as? String
                if let tags = tagStrings
                {
                    for tag in tags
                    {
                        spotTags.append(SkateSpot.SpotTag.toSpotTag(spotTagString: tag))
                    }
                }
                var comments = [String:[String]]()
                if let UserComments = value["UserComments"] as? [String:Any] {
                    comments = (UserComments["comments"] as? [String:[String]])!
                }
                
                
                let skateSpot = SkateSpot(userId: userID!, type: spotType, title: title, spotDescription: subtitle, rating: spotRating, spotImage: nil, coordinates: coordinate, imageURL: imageURL!,tags: spotTags, spotID: spotID!, username: username!, comments: comments)

                skateSpots.append(skateSpot)
                
            }
            completion(skateSpots)
            
        })
    }
    
    static func fetchUsers(completion: @escaping ([User])->())
    {
        var users = [User]()
        
        ref.child("users").observe(.childAdded) { (snap) in
           
            
            if let dictionary = snap.value as? [String:Any]
            {
                let tempUser = User()
                tempUser.userID = snap.key
                tempUser.name = dictionary["name"] as? String
                users.append(tempUser)
                print(tempUser.name)
            }
    
            completion(users)
            
        }
    }
    
    static func getUserName(userID: String, completion: @escaping (String)->()) {
       // guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        var username = ""
        
        let userRef = ref.child("users/\(userID)")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            username = value?["name"] as? String ?? ""
            completion(username)
        }
    }
    
    static func downloadProfileImage(userID: String, completion: @escaping (UIImage) -> ()) {
       // guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let userRef = ref.child("users/\(userID)/profile")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let url = value?["profileImageURL"] as? String ?? ""
           
            let configuration = URLSessionConfiguration.default
            let session: URLSession = URLSession(configuration: configuration)
            guard let imageURL = URL(string: url) else { return }
            
            let downloadTask: URLSessionDownloadTask = session.downloadTask(with: imageURL) { (url, response, error)  in
                let data = NSData(contentsOf: url!)
                guard let image = UIImage(data: data! as Data) else { return }
                completion(image)
            }
            
            downloadTask.resume()
        
        }
    }
    
    static func observeMessages()
    {
        let userMessageRef = ref.child("messages").child("user-messages").child(currentUserId)
        
        userMessageRef.observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            let messageId = snapshot.key
            let messagesRef = ref.child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with: { (snap) in
                print(snapshot)
            })
        }
    }
//    static func observeMessages(completion: @escaping ([Message]) -> ())
//    {
//        let messageRef = ref.child("messages")
//        var messages = [Message]()
//
//        messageRef.observe(.childAdded) { (snap) in
//
//            if let dictionary = snap.value as? [String:String]
//            {
//                let message = Message(fromID: dictionary["fromId"], text: dictionary["text"], toID: dictionary["toId"])
//
//                messages.append(message)
//            }
//        }
//
//        completion(messages)
//    }
    
    static func observeUserMessages(user:User,completion: @escaping ([Message]) -> ())
    {
        let messageRef = ref.child("messages").child("user-messages").child(currentUserId)
        var messages = [Message]()
        
        messageRef.observe(.childAdded) { (snapshot) in
            
            let messageId = snapshot.key
            let messagesReference = ref.child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snap) in
                
                if let dictionary = snap.value as? [String:String]
                {
                    
                    let message = Message(fromID: dictionary["fromId"], text: dictionary["text"], toID: dictionary["toId"])
     
                        if(message.chatPartnerId() == user.userID)
                        {
                            print(message.text)
                            messages.append(message)
                        }
                    
                        completion(messages)
                }
            })
            }
        
    }
    
    
    static func sendMessage(text:String,toUserId:String)
    {
       let userRef = ref.child("messages")
       let childRef = userRef.childByAutoId()
       let values = ["text": text,"fromId":currentUserId,"toId":toUserId]
        childRef.updateChildValues(values) { (error, reference) in
            
            if error != nil
            {
                print(error!.localizedDescription)
            }
            
            let userMessagesRef = userRef.child("user-messages").child(currentUserId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let receipientUserMessagesRef = userRef.child("user-messages").child(toUserId)
            receipientUserMessagesRef.updateChildValues([messageId:1])
        }
    }
    
    static func downloadSpotProfileImage(userID: String, completion: @escaping (UIImage) -> ()) {
        let userRef = ref.child("users/\(userID)/profile")
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let url = value?["profileImageURL"] as? String ?? ""
            
            let configuration = URLSessionConfiguration.default
            let session: URLSession = URLSession(configuration: configuration)
            guard let imageURL = URL(string: url) else { return }
            
            let downloadTask: URLSessionDownloadTask = session.downloadTask(with: imageURL) { (url, response, error)  in
                let data = NSData(contentsOf: url!)
                guard let image = UIImage(data: data! as Data) else { return }
                completion(image)
            }
            
            downloadTask.resume()
            
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
    
    static func saveRatedSpots(ratedSpots:[String]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let favouriteSpotsRef = ref.child("users/\(currentUserID)/ratedSpots")
        
        let rated = ["spots": ratedSpots] as [String : Any]
        favouriteSpotsRef.setValue(rated)
    }
    
    static func getRatedSpots(completion: @escaping ([String]) -> ()) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        var ratedSpots = [String]()
        let ratedeSpotsRef = ref.child("users/\(currentUserID)/ratedSpots")
        
        ratedeSpotsRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                ratedSpots = (value!["spots"] as? [String]) ?? [String]()
            }
            
            completion(ratedSpots)
        }
        
    }
    
    static func saveParkFavourites(favourites:[String]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let favouriteSpotsRef = ref.child("users/\(currentUserID)/favouriteParks")
        
        let favourites = ["parks": favourites] as [String : Any]
        favouriteSpotsRef.setValue(favourites)
    }
    
    static func getParkFavourites(completion: @escaping ([String]) -> ()) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        var favouriteSpots = [String]()
        let favouriteSpotsRef = ref.child("users/\(currentUserID)/favouriteParks")
        
        favouriteSpotsRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                favouriteSpots = (value!["parks"] as? [String]) ?? [String]()
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
            let image = UIImage(data: data! as Data)
            if image != nil
            {
            completion(image!)
            }
            else
            {
                completion(#imageLiteral(resourceName: "shop"))
            }
        }
        
        downloadTask.resume()
    }
    
    static func saveProfileImage(image: UIImage) {
        let randomFileName = "\(UUID().uuidString).png"
        
        // guard let image = spot.pinImage, let imageData = UIImagePNGRepresentation(image) else {return }
        
        guard let currentUserID = Auth.auth().currentUser?.uid, let resizedImage = image.resizeWith(percentage: 0.1), let resizedImageData = UIImagePNGRepresentation(resizedImage) else { return }
        
        let imageRef = Storage.storage().reference().child("profileImages").child("\(currentUserID)/\(randomFileName)")
        
        imageRef.putData(resizedImageData, metadata: nil, completion: { (metadata, error) in
            if let error = error  {
                print(error.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                guard let url = url else { return }
                
                let userRef = ref.child("users/\(currentUserID)/profile")
                
                let profileImageUrl = ["profileImageURL": url.absoluteString] as [String : Any]
                userRef.setValue(profileImageUrl)
            })
        })
    }
    
    static func saveSpotComments(spot: SkateSpot) {
        guard let spotID = spot.spotID else { return }
        let path = "skatespots/\(spotID)/UserComments"
        print(#line, path)
        let spotRef = ref.child(path)
        let comments = ["comments": spot.commentsToDictionary()] as [String : Any]
        spotRef.setValue(comments)

    }
    
    static func saveSpotRating(spot: SkateSpot) {
        guard let spotID = spot.spotID else { return }
        let path = "skatespots/\(spotID)/rating"
        print(#line, path)
        let spotRef = ref.child(path)
        let rating = spot.spotRatingData
        spotRef.setValue(rating)
        
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
