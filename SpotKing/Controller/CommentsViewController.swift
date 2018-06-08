//
//  CommentsViewController.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-08.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    var comments : [String:String]?
    var footer : CommentsFooterReusableView?
  //  var keys = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
    //    keys = comments?.keys
    }
    


}

extension CommentsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
        
        cell.username.text = Array(comments!)[indexPath.row].key
        cell.comment.text = Array(comments!)[indexPath.row].value
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind ==  UICollectionElementKindSectionFooter {
            self.footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentsFooter", for:indexPath) as? CommentsFooterReusableView
            
//            if(!isHeaderSet)
//            {
//                setUpDetailContainerView()
//            }
            
            return self.footer!
        }
        
        
        return UICollectionReusableView()
    }
}
