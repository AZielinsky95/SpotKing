//
//  NetworkManager.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-05-31.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NetworkManager: NSObject
{
    
    static func getSkateShopAndParkImageURL(photoref:String) -> String?
    {
        guard var URL = URL(string: "https://maps.googleapis.com/maps/api/place/photo") else {return nil}
        
        let URLParams = [
            "photo_reference": photoref,
            "key": "AIzaSyCV01vbVIhaZQUitWBtdv3ymzBBvipwRmA",
            "maxwidth": "\(256)",
            ]
        
        URL = URL.appendingQueryParameters(URLParams)
        return URL.absoluteString
    }
    
    static func getSkateSpot(location: CLLocationCoordinate2D,type:SkateSpot.SpotType,completion: @escaping ([SkateSpot]) -> Void)
    {
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json") else {return}
        
        var keyword = ""
        
        if type == .SkatePark
        {
            keyword = "SkatePark"
        }
        else if type == .SkateShop
        {
            keyword = "SkateboardShop";
        }
        
        let URLParams = [
            "location": "\(location.latitude),\(location.longitude)",
            "radius": "5000",
            "keyword": "\(keyword)",
            "key": "AIzaSyA_-acdQ-vkOXl6GDEiF_VDZY6bjq40l6I",
            ]
        
        url = url.appendingQueryParameters(URLParams)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] else { return }
            
            guard let jsonDictionary = json!["results"]  as? [Dictionary<String, Any>]else { return }
            
            
            var spots = [SkateSpot]()
            
            for location in jsonDictionary
            {
//                var imageURL :String?
//                if let photos = location["photos"] as? [[String:Any]]
//                {
//                 let photoReference = photos[0]["photo_reference"] as! String
//                 imageURL = getSkateShopAndParkImageURL(photoref: photoReference)
//                }
                let spot = SkateSpot(json:location,type: type)
       //         spot.imageURL = imageURL
                spots.append(spot);
            }
            
            completion(spots);
            
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    static func getSpotDetails(spot:SkateSpot,placeID:String)
    {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard var URL = URL(string: "https://maps.googleapis.com/maps/api/place/details/json") else {return}
        let URLParams = [
            "placeid": "\(placeID)",
            "key": "AIzaSyA_-acdQ-vkOXl6GDEiF_VDZY6bjq40l6I",
            ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] else { return }
            
            guard let jsonDictionary = json!["result"] as? Dictionary<String, Any> else { return }
            

            let phoneNumber = jsonDictionary["formatted_phone_number"] as? String
            spot.phoneNumber = phoneNumber
            
            let website = jsonDictionary["website"] as? String
            spot.website = website
            
            var imageURL :String?
            if let photos = jsonDictionary["photos"] as? [[String:Any]]
            {
             let photoReference = photos[1]["photo_reference"] as! String
             imageURL = getSkateShopAndParkImageURL(photoref: photoReference)
            }
            spot.imageURL = imageURL
            
            guard let reviews = jsonDictionary["reviews"] as? [Dictionary<String, Any>] else { return }
            spot.reviews = reviews
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }

    
}


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}




