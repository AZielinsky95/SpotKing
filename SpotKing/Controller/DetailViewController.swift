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
        self.navigationItem.title = spot?.title
        usernameLabel.text = spot?.userID
        descriptionLabel.text = spot?.subtitle
        spotImageView.image = spot?.spotImage
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
}
