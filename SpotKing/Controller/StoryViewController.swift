//
//  StoryViewController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-04.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit
import FirebaseAuth

class StoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var skateSpots : [SkateSpot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        
        DatabaseManager.getSpotFavourites { (favouriteSpots) in
            User.favouriteSpots = favouriteSpots
        }
        
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "map")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "map")

     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentsSegue" {
            
            guard let button = sender as? UIButton, let cell = button.superview?.superview?.superview as? StoryCell,
                let indexPath =  collectionView.indexPath(for: cell) else { return }
            
            let commentsVC = segue.destination as! CommentsViewController
            let spot = skateSpots![indexPath.row]
            commentsVC.commentsTuple = spot.comments
            commentsVC.skateSpot = spot
            commentsVC.spotIndex = indexPath.row
            commentsVC.delegate = self
            
        }
        else if segue.identifier == "AddCommentSegue" {
            
            guard let textField = sender as? UITextField, let cell = textField.superview?.superview?.superview?.superview as? StoryCell,
                let indexPath =  collectionView.indexPath(for: cell) else { return }
            
            let commentsVC = segue.destination as! CommentsViewController
            let spot = skateSpots![indexPath.row]
            commentsVC.commentsTuple = spot.comments
            commentsVC.skateSpot = spot
            commentsVC.spotIndex = indexPath.row
            commentsVC.delegate = self
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
        
        cell.commentProfileImageView.layer.cornerRadius = cell.commentProfileImageView.frame.size.width / 2
        cell.commentProfileImageView.clipsToBounds = true
    
        cell.commentProfileImageView.image = User.profileImage
        cell.commentTextField.layer.cornerRadius = 5
        
        cell.profileImage.image = spot.userProfileImage
        
        cell.imageView.image = spot.spotImage
        cell.spotTitle.text = spot.title
        cell.spotDescription.text = spot.spotDescription
        cell.username.text = spot.username

        cell.commentTextField.delegate = self
        
        cell.viewCommentsButton.isHidden = spot.comments.count == 0 ? true : false
        cell.viewCommentsButton.setTitle("View \(spot.comments.count) comments", for: .normal)
        
        cell.username.isHidden = spot.spotType != SkateSpot.SpotType.SkateSpot ? true : false
        cell.profileImage.isHidden = spot.spotType != SkateSpot.SpotType.SkateSpot ? true : false
        
        if spot.spotType != SkateSpot.SpotType.SkateSpot {
            cell.spotTitle.frame.origin.y = 215
        }
        else {
            cell.spotTitle.frame.origin.y = 244
        }
        
        let spotID = spot.spotID
        cell.spotID = spotID
        if spotID != nil {
            if User.favouriteSpots.contains(spotID!) || User.favouriteParks.contains(spotID!) {
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
        
        guard let indexPath = collectionView.indexPath(for: cell), let spotType = skateSpots![indexPath.row].spotType, let spotID = skateSpots![indexPath.row].spotID else { return }
        
        if spotType == .SkateSpot {
            if User.favouriteSpots.contains(spotID) {
                guard let index = User.favouriteSpots.index(of: spotID) else { return }
                User.favouriteSpots.remove(at: index)
                
            } else {
                User.favouriteSpots.append(spotID)
            }
            DatabaseManager.saveSpotFavourites(favourites: User.favouriteSpots)
        }
        if spotType == .SkatePark {
            if User.favouriteParks.contains(spotID) {
                guard let index = User.favouriteParks.index(of: spotID) else { return }
                User.favouriteParks.remove(at: index)
                
            } else {
                User.favouriteParks.append(spotID)
            }
            DatabaseManager.saveParkFavourites(favourites: User.favouriteParks)
        }
        
        collectionView.reloadData()
    }
}

extension StoryViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let cell = textField.superview?.superview?.superview?.superview as? StoryCell,
            let indexPath =  collectionView.indexPath(for: cell), let userID = Auth.auth().currentUser?.uid else { fatalError() }
        
        if let comment = textField.text {
            self.skateSpots![indexPath.row].comments.append((userID, comment))
            DatabaseManager.saveSpotComments(spot: self.skateSpots![indexPath.row])
            textField.text = ""
            performSegue(withIdentifier: "AddCommentSegue", sender: textField)
        }
        
        return true
    }
}

extension StoryViewController : CommentsProtocol {
    func updateSpot(index: Int, spot: SkateSpot) {
        self.skateSpots![index] = spot
        self.collectionView.reloadData()
    }
}
