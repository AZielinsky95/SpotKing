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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.title = spot?.title
        titleLabel.text = spot?.title
        
        if let type = spot?.spotType
        {
            switch type {
            case SkateSpot.SpotType.SkateShop:
                usernameLabel.isHidden = true;
                profileImageView.isHidden = true;
                addressLabel.isHidden = false
                break;
            case SkateSpot.SpotType.SkatePark:
                usernameLabel.isHidden = true;
                profileImageView.isHidden = true;
                addressLabel.isHidden = false
                break;
            case SkateSpot.SpotType.SkateSpot:
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
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
}
