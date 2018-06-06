//
//  SkateSpot.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-05-31.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class SkateSpot : NSObject, MKAnnotation
{
    enum SpotType {
        case SkatePark
        case SkateShop
        case SkateSpot
        
        func toString() -> String {
            switch self {
            case .SkatePark:
                return "SkatePark"
            case .SkateShop:
                return "SkateShop"
            case .SkateSpot:
                return "SkateSpot"
            }
        }
        
        static func toSpotType(strSpotType: String) -> SpotType {
            switch strSpotType {
            case "SkatePark":
                return SpotType.SkatePark
            case "SkateShop":
                return SpotType.SkateShop
            case "SkateSpot":
                return SpotType.SkateSpot
            default:
                return SpotType.SkatePark
            }
        }
    }
    
    enum SpotTag
    {
        case Rail
        case Stairs
        case Hubba
        case Gap
        case Manual
        
       func toString() -> String {
            switch self {
            case .Rail:
                return "Rail"
            case .Stairs:
                return "Stairs"
            case .Hubba:
                return "Hubba"
            case .Gap:
                return "Gap"
            case .Manual:
                return "Manual"
            }
        }
        
        static func toSpotTag(spotTagString: String) -> SpotTag
        {
            switch spotTagString {
            case "Rail":
                return SpotTag.Rail
            case "Stairs":
                return SpotTag.Stairs
            case "Hubba":
                return SpotTag.Hubba
            case "Gap":
                return SpotTag.Gap
            case "Manual":
                return SpotTag.Manual
            default:
                return SpotTag.Rail
            }
        }
    }
    
    
    var userID: String!
    var spotType:SpotType!
    var title:String?
    var spotDescription:String?
    var spotImage:UIImage?
    var coordinate = CLLocationCoordinate2D()
    var spotRating:Double?
    var imageURL:String?
    var spotTags:[SpotTag]?
    var spotID: String!
    
    lazy var pinImageAndColor : (UIImage,UIColor) =
    {
            switch spotType! {
            case SkateSpot.SpotType.SkatePark:
                return (UIImage(named: "crown")!,UIColor.magenta);
            case SkateSpot.SpotType.SkateSpot:
                return (UIImage(named: "spotIcon")!,UIColor.SpotKingColors.lightGreen);
            case SkateSpot.SpotType.SkateShop:
                return (UIImage(named: "bag")!,UIColor.red);
            }
    }()
    
    init(userId:String,type:SpotType,title:String,spotDescription:String,rating:Double?,spotImage:UIImage?,coordinates:CLLocationCoordinate2D, imageURL:String,tags:[SpotTag]?, spotID:String)
    {
        self.userID = userId
        self.spotType = type
        self.title = title
        self.spotDescription = spotDescription
        self.spotRating = rating
        self.spotImage = spotImage
        self.coordinate = coordinates
        self.imageURL = imageURL
        self.spotTags = tags
        self.spotID = spotID
        super.init()
    }
    
    init(json:[String:Any],type:SpotType)
    {
        super.init()
        guard let geometry = json["geometry"] as? [String:Any] else { return }
        guard let location = geometry["location"] as? [String:Double] else { return }
        
        spotType = type;
        title = json["name"] as? String;
        spotRating = json["rating"] as? Double;
        coordinate = CLLocationCoordinate2D(latitude: location["lat"]!, longitude: location["lng"]!)
        
    }
    
    func spotTagsToStringArray() -> [String]
    {
        var result = [String]()
        
        if let tags = spotTags
        {
            for tag in tags
            {
                let tagString = tag.toString()
                result.append(tagString)
            }
        }
        
        return result
    }
    
    func ratingToStars() -> String
    {
        switch (Int(spotRating!))
        {
            case 1:
            return "⭐️";
            case 2:
            return "⭐️⭐️";
            case 3:
            return "⭐️⭐️⭐️";
            case 4:
            return "⭐️⭐️⭐️⭐️";
            case 5:
            return "⭐️⭐️⭐️⭐️⭐️";
            default:
            return "";
        }
    }
}
