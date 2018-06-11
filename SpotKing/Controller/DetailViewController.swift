//
//  DetailViewController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-05.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var header:DetailReusableView?
    
    var spot : SkateSpot?
    var comments = [Comment]()

    var ratingControlTopConstraintForShop:NSLayoutConstraint?
    
    var isHeaderSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "map"), style: .plain, target: self, action: #selector(BackToMap))
        self.navigationItem.title = spot?.title
        isHeaderSet = false
        setupComments()
        
    }
    
    @objc func BackToMap()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupComments() {
        
        guard let commentsTuple = spot?.comments else { return }
        
        for commentTuple in commentsTuple {
            let userID = commentTuple.0
            DatabaseManager.getUserName(userID: userID, completion: { (username) in
                let comment = Comment()
                comment.comment = commentTuple.1
                 comment.username = username
                self.comments.append(comment)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                        
            })
        }
        
    }
    
    
    func setUpDetailContainerView()
    {
        isHeaderSet = true
        setRating(rating: spot?.spotRating)
        header!.spotImageView.image = spot?.spotImage
        header!.detailContainerView.layer.cornerRadius = 5
        header!.detailContainerView.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        header!.detailContainerView.layer.borderWidth = 2

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
       header!.descriptionLabel.text = spot?.phoneNumber
       header!.usernameLabel.isHidden = true;
       header!.profileImageView.isHidden = true;
       header!.addressLabel.isHidden = false
       header!.addressLabel.text = spot?.address
       header!.ratingControl.isUserInteractionEnabled = false
    }
    
    func setUpSkateSpotView()
    {
        header!.titleLabel.text = "Comments"
        header!.usernameLabel.isHidden = false;
        header!.profileImageView.isHidden = false;
        header!.addressLabel.isHidden = true
        header!.ratingControl.isUserInteractionEnabled = true
        header!.profileImageView.layer.cornerRadius = ( header!.profileImageView.frame.size.width/2)
        header!.profileImageView.clipsToBounds = true
        header!.profileImageView.image = User.profileImage
        header!.usernameLabel.text = User.username
        header!.descriptionLabel.text = spot?.spotDescription
        ratingControlTopConstraintForShop?.isActive = false
        header!.ratingControlTopConstraint.isActive = true
        header!.ratingControl.delegate = self

        header!.websiteLabel.isHidden = true
    }

    func setUpSkateShopView()
    {
        header!.titleLabel.text = "Reviews"
        header!.usernameLabel.isHidden = true;
        header!.profileImageView.isHidden = true;
        header!.addressLabel.isHidden = false
        header!.addressLabel.text = spot?.address
        header!.ratingControl.isUserInteractionEnabled = false
        header!.descriptionLabel.text = spot?.phoneNumber
//        header!.detailContainerView.layer.shadowColor = UIColor.black.cgColor
//        header!.detailContainerView.layer.shadowOpacity = 0.5
//        header!.detailContainerView.layer.shadowOffset = CGSize.zero
//        header!.detailContainerView.layer.shadowRadius = 15
        header!.ratingControlTopConstraint.isActive = false;
        ratingControlTopConstraintForShop =  header!.ratingControl.topAnchor.constraint(equalTo: header!.usernameLabel.bottomAnchor, constant: 6)
        ratingControlTopConstraintForShop!.isActive = true

        header!.websiteLabel.isHidden = false
        header!.websiteLabel.text = spot?.website
    }

    func setRating(rating:Int?)
    {
        if spot?.spotType == SkateSpot.SpotType.SkateSpot && User.ratedSpots.contains((spot?.spotID)!) {
            if let rating = rating
            {
                header!.ratingControl.rating = rating
                header!.ratingControl.isUserInteractionEnabled = false
                return
            }
        }
        if spot?.spotType != SkateSpot.SpotType.SkateSpot {
            if let rating = rating
            {
                header!.ratingControl.rating = rating
                return
            }
        }
       
        header!.ratingControl.rating = 0;
    }
    
}


extension DetailViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(spot?.spotType == SkateSpot.SpotType.SkateShop)
        {
            return (spot?.reviews?.count)!
        }
        else if spot?.spotType == SkateSpot.SpotType.SkateSpot
        {
            return spot?.comments.count ?? 0
        }
        
        return 1
        //else if its a skate spot get number of comments
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            self.header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for:indexPath) as? DetailReusableView
            
         if(!isHeaderSet)
         {
           setUpDetailContainerView()
         }
           
           return self.header!
        }
        
   
         return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCell
        
        if spot?.spotType == SkateSpot.SpotType.SkateShop
        {
            let review = spot?.reviews![indexPath.row]
            cell.authorLabel.text = review!["author_name"] as! String
            cell.textLabel.text = review!["text"] as! String
        }
        else if spot?.spotType == SkateSpot.SpotType.SkateSpot
        {
            if comments.count > indexPath.row {
                cell.authorLabel.text = comments[indexPath.row].username
                cell.textLabel.text = comments[indexPath.row].comment
            }

            
            //Array(spot!.comments)[indexPath.row].value
        }
        
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOpacity = 0.5
//        cell.layer.shadowOffset = CGSize.zero
//        cell.layer.shadowRadius = 2
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        return cell
        
    }
    
    
    
}

extension DetailViewController : RatingProtocol {
    
    func updateRating(rating: Int) {
        guard var total = spot?.spotRatingData!["total"], var count = spot?.spotRatingData!["count"] else { return }
        count += 1
        total += rating
        let rating = Int(floor(Double(total)/Double(count)))
        spot?.spotRatingData = ["count":count, "total":total]
        spot?.spotRating = rating
        User.ratedSpots.append((spot?.spotID)!)
        DatabaseManager.saveRatedSpots(ratedSpots: User.ratedSpots)
        DatabaseManager.saveSpotRating(spot: spot!)
        setRating(rating: rating)
        
    }
}
