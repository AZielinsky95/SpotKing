//
//  DetailViewController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-05.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var spotImageView: UIImageView!
    
    var spot : SkateSpot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContainer.layer.cornerRadius = 5
        viewContainer.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        viewContainer.layer.borderWidth = 3
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOpacity = 1
        viewContainer.layer.shadowOffset = CGSize.zero
        viewContainer.layer.shadowRadius = 10
        self.navigationItem.title = spot?.title
        
        if let type = spot?.spotType
        {
            switch type {
            case SkateSpot.SpotType.SkateShop:
                usernameLabel.isHidden = true;
                break;
            case SkateSpot.SpotType.SkatePark:
                usernameLabel.isHidden = true;
                break;
            case SkateSpot.SpotType.SkateSpot:
                DatabaseManager.getUserName(userID: (spot?.userID)!) { (username) in
                    self.usernameLabel.text = username
                }
                break;
            }
        }
    
        descriptionLabel.text = spot?.spotDescription
        spotImageView.image = spot?.spotImage
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
}
