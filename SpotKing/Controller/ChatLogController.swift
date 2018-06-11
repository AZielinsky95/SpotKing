//
//  ChatLogController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-09.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChatLogController: UICollectionViewController,UITextFieldDelegate,UICollectionViewDelegateFlowLayout {

    var user : User?
    {
        didSet
        {
            navigationItem.title = user?.name
           // observeMessages()
        }
    }
    
    func observeMessages()
    {
        DatabaseManager.observeMessages()
    }
    
    var messages : [Message]?
    
    lazy var inputTextField:UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(ChatMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundColor = UIColor.white
        
        setupInputComponents()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        DatabaseManager.observeUserMessages(user:user!) { (messages) in
            DispatchQueue.main.async
            {
                self.messages = messages
                self.collectionView?.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        if let text = messages![indexPath.item].text
        {
            height = estimatedFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimatedFrameForText(text:String) -> CGRect
    {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
        
        return NSString(string:text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func setupInputComponents()
    {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo:containerView.heightAnchor).isActive = true
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor.black
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorView)
        seperatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
    }
    
    @objc func handleSend()
    {
        guard let message = inputTextField.text else { return }
        DatabaseManager.sendMessage(text: message,toUserId: self.user!.userID!)
        inputTextField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messages?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatMessageCell
        
        let message = messages![indexPath.item]
        cell.textView.text = message.text
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 32
        
        setupCell(cell: cell, message: message)
    
        return cell
    }
    
    func setupCell(cell:ChatMessageCell,message:Message)
    {
        if(message.fromId == DatabaseManager.currentUserId)
        {
            cell.bubbleView.backgroundColor = UIColor.SpotKingColors.lightBlue
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleLeftAnchor?.isActive = false
            cell.bubbleRightAnchor?.isActive = true
        }
        else
        {
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            cell.profileImageView.image = user?.userImage
        }
    }
}

