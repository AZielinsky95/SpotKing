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
        
//        DatabaseManager.getSkateSpots { (spots) in
//           self.skateSpots = spots.reversed()
//
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//
//        }
        
        
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
        
//        DatabaseManager.downloadSkateSpotImage(url: skateSpots![indexPath.row].imageURL!) { (image) in
//            DispatchQueue.main.async {
//                cell.imageView.image = image
//
//             //   self.collectionView.reloadData()
//            }
//
//        }
        cell.imageView.image = skateSpots![indexPath.row].spotImage
        cell.spotTitle.text = skateSpots![indexPath.row].title
        cell.spotDescription.text = skateSpots![indexPath.row].subtitle
        
//        DatabaseManager.getUserName(userID: skateSpots![indexPath.row].userID) { (username) in
//            DispatchQueue.main.async {
//            cell.username.text = username
//                
//            }
//        }
      
        return cell
    }
}
