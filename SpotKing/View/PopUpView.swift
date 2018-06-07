//
//  PopUpView.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-06.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class PopUpView: UIView
{
    let popUpLabel : UILabel =
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 175, height: 45))
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    
    let iconImageView : UIImageView =
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width:32, height:32))
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true;
        return imageView
    }()
    
    init(frame:CGRect,text:String,image:UIImage) {
         super.init(frame: frame)
         popUpLabel.text = text
         iconImageView.image = image
         setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView()
    {
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 15
        layer.cornerRadius = 5
        layer.borderColor = UIColor.SpotKingColors.lightGreen.cgColor
        layer.borderWidth = 3
        
        addSubview(popUpLabel)
        addSubview(iconImageView)
        
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 24).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        popUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 8).isActive = true
        popUpLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
}
