//
//  DetailViewController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-05.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var spotImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var spot : SkateSpot?
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.title = spot?.title
        titleLabel.text = spot?.title
        setRating(rating: spot?.spotRating)
    
        if let type = spot?.spotType
        {
            switch type {
            case SkateSpot.SpotType.SkateShop:
                usernameLabel.isHidden = true;
                profileImageView.isHidden = true;
                addressLabel.isHidden = false
                addressLabel.text = spot?.address
                ratingControl.isUserInteractionEnabled = false
                break;
            case SkateSpot.SpotType.SkatePark:
                usernameLabel.isHidden = true;
                profileImageView.isHidden = true;
                addressLabel.isHidden = false
                addressLabel.text = spot?.address
                ratingControl.isUserInteractionEnabled = false
                break;
            case SkateSpot.SpotType.SkateSpot:
                usernameLabel.isHidden = false;
                profileImageView.isHidden = false;
                addressLabel.isHidden = true
                ratingControl.isUserInteractionEnabled = true
                self.profileImageView.layer.cornerRadius = (self.profileImageView.frame.size.width/2)
                self.profileImageView.clipsToBounds = true
                self.profileImageView.image = User.profileImage
                self.usernameLabel.text = User.username
                break;
            }
        }
    
        descriptionLabel.text = spot?.spotDescription
        spotImageView.image = spot?.spotImage
    }
    
    func setRating(rating:Double?)
    {
        if let rating = rating
        {
            ratingControl.rating = Int(rating)
        }
        else
        {
            ratingControl.rating = 0;
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
}
