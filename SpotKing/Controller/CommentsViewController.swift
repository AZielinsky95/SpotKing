//
//  CommentsViewController.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-08.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol CommentsProtocol : class {
    func updateSpot(index: Int, spot: SkateSpot)
}


class CommentsViewController: UIViewController {
    
    var commentsTuple = [(String, String)]()
    var comments = [Comment]()
    var skateSpot : SkateSpot?
    var footer : CommentsFooterReusableView?
    var spotIndex: Int?
    //  var keys = [String]()
    weak var delegate : CommentsProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var commentsTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupComments()
       
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)


    }
    
    func setupView() {
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "news")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "news")
        self.collectionView.dataSource = self
        self.title = "Comments"
        self.profileImageView.image = User.profileImage
        self.commentsTextField.delegate = self
        self.commentsTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.commentsTextField.layer.borderWidth = 1
        self.commentsTextField.layer.cornerRadius = 5
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.clipsToBounds = true
        
    }
    
    func setupComments() {
        
        for commentTuple in commentsTuple {
            let userID = commentTuple.0
            DatabaseManager.downloadProfileImage(userID: userID) { (image) in
                DatabaseManager.getUserName(userID: userID, completion: { (username) in
                    let comment = Comment()
                    comment.comment = commentTuple.1
                    comment.profileImage = image
                    comment.username = username
                    self.comments.append(comment)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                        self.collectionView.scrollToItem(at: IndexPath(row: self.comments.count-1, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
                        
                    }
                })
            }
        }

    }
    
    func addComment(userID: String, commentText: String) {
            DatabaseManager.downloadProfileImage(userID: userID) { (image) in
                DatabaseManager.getUserName(userID: userID, completion: { (username) in
                    let comment = Comment()
                    comment.comment = commentText
                    comment.profileImage = image
                    comment.username = username
                    self.comments.append(comment)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                        self.collectionView.scrollToItem(at: IndexPath(row: self.comments.count-1, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
                    }
                })
            }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 258 //keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y =  0
            }
        }
    }
        
}

extension CommentsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
        cell.commentImageView.layer.cornerRadius = cell.commentImageView.frame.width / 2
        cell.commentImageView.clipsToBounds = true
        
        cell.username.textColor = UIColor.SpotKingColors.darkGreen
        cell.username.text = comments[indexPath.row].username
        cell.comment.text = comments[indexPath.row].comment
        cell.commentImageView.image = comments[indexPath.row].profileImage
        
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor

        
       return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind ==  UICollectionElementKindSectionFooter {
//            self.footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentsFooter", for:indexPath) as? CommentsFooterReusableView
//
//            print(#line, "indexpath:", indexPath.row, indexPath.section)
//            self.footer?.profileImageView.image = User.profileImage
//            self.footer?.profileImageView.layer.cornerRadius = (self.footer?.profileImageView.frame.width)! / 2
//            self.footer?.profileImageView.clipsToBounds = true
//
//            self.footer?.commentsTextField.delegate = self
//
//
//            return self.footer!
//        }
//
//        return UICollectionReusableView()
//    }
}

extension CommentsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let userID = Auth.auth().currentUser?.uid else { fatalError() }
//
        if let comment = textField.text {
            if comment != "" {
                addComment(userID: userID, commentText: comment)
                skateSpot?.comments.append((userID, comment))
                delegate?.updateSpot(index: spotIndex!, spot: skateSpot!)
                DatabaseManager.saveSpotComments(spot: skateSpot!)
            }

            textField.text = ""
            textField.resignFirstResponder()
            
        }
        
        return true
    }
}
