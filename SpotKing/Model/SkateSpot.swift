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
    
    var userID: Int!
    var spotType:SpotType!
    var title:String?
    var subtitle:String?
    var pinImage:UIImage?
    var coordinate = CLLocationCoordinate2D()
    var spotRating:Double?
    var imageURL:String?
    
 init(userId:Int,type:SpotType,title:String,subtitle:String,rating:Double?,pinImage:UIImage?,coordinates:CLLocationCoordinate2D)
    {
        self.userID = userId;
        self.spotType = type;
        self.title = title;
        self.subtitle = subtitle;
        self.spotRating = rating;
        self.pinImage = pinImage;
        self.coordinate = coordinates;
        super.init()
    }
    
    init(json:[String:Any],type:SpotType)
    {
        super.init()
        guard let geometry = json["geometry"] as? [String:Any] else { return }
        guard let location = geometry["location"] as? [String:Double] else { return }
        
        if(type == SpotType.SkatePark)
        {
            self.pinImage = UIImage(named: "crown");
        }
        else if (type == SpotType.SkateShop)
        {
            self.pinImage = UIImage(named: "bag")
        }
        
        spotType = type;
        title = json["name"] as? String;
        spotRating = json["rating"] as? Double;
        coordinate = CLLocationCoordinate2D(latitude: location["lat"]!, longitude: location["lng"]!)
        
    }
}
