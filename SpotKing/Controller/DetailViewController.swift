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
    
    @IBOutlet weak var ratingControlTopConstraint: NSLayoutConstraint!
    var ratingControlTopConstraintForShop:NSLayoutConstraint?
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var detailContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.title = spot?.title
        titleLabel.text = spot?.title
        setRating(rating: spot?.spotRating)
        spotImageView.image = spot?.spotImage
        
        setUpDetailContainerView()  
    }
    
    func setUpDetailContainerView()
    {
        detailContainerView.layer.cornerRadius = 5
        detailContainerView.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        detailContainerView.layer.borderWidth = 2
        
        if let type = spot?.spotType
        {
            switch type {
            case SkateSpot.SpotType.SkateShop:
                setUpSkateShopView()
                break;
            case SkateSpot.SpotType.SkatePark:
                setUpSkateParkView()
                break;
            case SkateSpot.SpotType.SkateSpot:
                setUpSkateSpotView()
                break;
            }
        }
    }
    
    func setUpSkateParkView()
    {
        descriptionLabel.text = spot?.phoneNumber
        usernameLabel.isHidden = true;
        profileImageView.isHidden = true;
        addressLabel.isHidden = false
        addressLabel.text = spot?.address
        ratingControl.isUserInteractionEnabled = false
    }
    
    func setUpSkateSpotView()
    {
        usernameLabel.isHidden = false;
        profileImageView.isHidden = false;
        addressLabel.isHidden = true
        ratingControl.isUserInteractionEnabled = true
        self.profileImageView.layer.cornerRadius = (self.profileImageView.frame.size.width/2)
        self.profileImageView.clipsToBounds = true
        self.profileImageView.image = User.profileImage
        self.usernameLabel.text = User.username
        descriptionLabel.text = spot?.spotDescription
        
        ratingControlTopConstraintForShop?.isActive = false
        ratingControlTopConstraint.isActive = true
        
        websiteLabel.isHidden = true
    }
    
    func setUpSkateShopView()
    {
        usernameLabel.isHidden = true;
        profileImageView.isHidden = true;
        addressLabel.isHidden = false
        addressLabel.text = spot?.address
        ratingControl.isUserInteractionEnabled = false
        descriptionLabel.text = spot?.phoneNumber
        
        ratingControlTopConstraint.isActive = false;
        ratingControlTopConstraintForShop = ratingControl.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 6)
        ratingControlTopConstraintForShop!.isActive = true
        
        websiteLabel.isHidden = false
        websiteLabel.text = spot?.website
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
