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

class SkateSpot
{
    enum SpotType {
        case SkatePark
        case SkateShop
        case SkateSpot
    }
    
    var userID: Int!
    var spotType:SpotType!
    var title:String?
    var subtitle:String?
    var image:UIImage?
    var coordinate = CLLocationCoordinate2D()
    var spotRating:Double!
}
