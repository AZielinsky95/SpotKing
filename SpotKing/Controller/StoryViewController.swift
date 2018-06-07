//
//  StoryViewController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-04.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var skateSpots : [SkateSpot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        
        DatabaseManager.getSpotFavourites { (favouriteSpots) in
            User.favouriteSpots = favouriteSpots
        }
        
    }
}

extension StoryViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if skateSpots == nil {
            return 0
        }
        
        return skateSpots!.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCell
        
        guard let spot = skateSpots?[indexPath.row] else { fatalError() }
        
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
        cell.profileImage.clipsToBounds = true
    
        cell.profileImage.image = spot.userProfileImage
        
        cell.imageView.image = spot.spotImage
        cell.spotTitle.text = spot.title
        cell.spotDescription.text = spot.spotDescription
        cell.username.text = spot.username

        cell.username.isHidden = spot.spotType != SkateSpot.SpotType.SkateSpot ? true : false
        cell.profileImage.isHidden = spot.spotType != SkateSpot.SpotType.SkateSpot ? true : false
        
        let spotID = spot.spotID
        cell.spotID = spotID
        if spotID != nil {
            if User.favouriteSpots.contains(spotID!) {
                cell.favouriteButton.setImage(UIImage(named: "heart"), for: .normal)
            } else {
                cell.favouriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)
            }
        }

        cell.delegate = self
        
        return cell
    }
}

extension StoryViewController : StoryCellDelegate {
    func favouriteClicked(cell: StoryCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell), let spotID = skateSpots![indexPath.row].spotID
            else { return }
        
        if User.favouriteSpots.contains(spotID) {
            guard let index = User.favouriteSpots.index(of: spotID) else { return }
            User.favouriteSpots.remove(at: index)
            
        } else {
            User.favouriteSpots.append(spotID)            
        }
        DatabaseManager.saveSpotFavourites(favourites: User.favouriteSpots)
        
      
        collectionView.reloadData()
    }
}
