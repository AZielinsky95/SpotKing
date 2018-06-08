//
//  StoryCell.swift
//  SpotKing
//
//  Created by Michael Chebotarov on 2018-06-05.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

protocol StoryCellDelegate : class {
    func favouriteClicked(cell: StoryCell)
}

class StoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var spotTitle: UILabel!
    @IBOutlet weak var spotDescription: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    @IBOutlet weak var commentProfileImageView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    weak var delegate : StoryCellDelegate?
    
    var spotID: String?
    
    @IBAction func favouritePressed() {
        delegate?.favouriteClicked(cell: self)
    }
    
}
