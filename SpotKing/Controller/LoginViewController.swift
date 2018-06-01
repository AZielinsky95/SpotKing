//
//  LoginViewController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-01.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let inputContainerView : UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginButton : UIButton =
    {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    let usernameTextField : UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(inputContainerView)
        view.addSubview(loginButton)
        setUpInputContainerView()
        setUpLoginButton()
    }
    
    func setUpLoginButton()
    {
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        loginButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true;
        loginButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        loginButton.heightAnchor.constraint(equalToConstant: 80);
    }
    
    func setUpInputContainerView()
    {
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true;
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true;
        
        inputContainerView.addSubview(usernameTextField)
    }
    
}

extension UIColor
{
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat)
    {
      self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    struct SpotKingColors
    {
       static let lightGreen = UIColor.init(r: 111, g: 201, b: 174)
       static let darkGreen = UIColor.init(r: 58, g: 162, b: 139)
        
    }
}
