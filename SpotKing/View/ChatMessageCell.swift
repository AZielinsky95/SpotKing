//
//  ChatMessageCell.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-10.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell
{
    let textView : UITextView = {
      
        let tv = UITextView()
        tv.text = "Sample For now"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        return tv
    }()
    
    let bubbleView : UIView =
    {
      let view = UIView()
        view.backgroundColor = UIColor(r:0,g:137,b:249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
        addSubview(bubbleView)
        addSubview(textView)
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant:200)
            
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor,constant:8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      //  textView.widthAnchor.constraint(equalToConstant:200).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
