//
//  User.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-06.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class User: NSObject {
    
    //Warning : terribly designed!
    
    //for current user!
    static var username : String!
    static var favouriteSpots = [String]()
    static var profileImage : UIImage?
    static var favouriteParks = [String]()
    static var ratedSpots = [String]()
    
    //For other users!
    var name: String?
    var userID: String?
    var userImage: UIImage?
}

