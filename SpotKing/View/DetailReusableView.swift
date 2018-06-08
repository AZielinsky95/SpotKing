//
//  DetailReusableView.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-08.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class DetailReusableView: UICollectionReusableView
{
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var spotImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var detailContainerView: UIView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var ratingControlTopConstraint: NSLayoutConstraint!
    
}
