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
    
    //For other users!
    var name: String?
    var userID: String?
    var userImage: UIImage?
}

class UserCell: UITableViewCell
{
    let profileImageView : UIImageView =
    {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius =  20
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
