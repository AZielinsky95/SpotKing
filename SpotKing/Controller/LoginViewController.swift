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
    
    let loginRegisterButton : UIButton =
    {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    let titleLabel : UILabel =
    {
        let label = UILabel()
        label.text = "Spot King"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 36);
        label.textColor = UIColor.black;
        return label
    }()
    
    let usernameTextField : UITextField =
    {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.white
        return textField
    }()
    
    let usernameSeperatorView : UIView =
    {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let emailTextField : UITextField =
    {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "e-mail", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.white
        return textField
    }()
    
    let emailSeperatorView : UIView =
    {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let passwordTextField : UITextField =
    {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.SpotKingColors.lightGreen
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        setUpInputContainerView()
        setUpLoginButton()
        setUpTitle()
    }
    
    func setUpTitle()
    {
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -100).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true;
    }
    
    func setUpLoginButton()
    {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true;
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 80);
    }
    
    func setUpInputContainerView()
    {
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true;
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true;
        
        inputContainerView.addSubview(usernameTextField)
        usernameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true;
        usernameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true;
        usernameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true;
        
        inputContainerView.addSubview(usernameSeperatorView)
        usernameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true;
        usernameSeperatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true;
        usernameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        usernameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true;
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true;
        emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true;
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true;
        
        inputContainerView.addSubview(emailSeperatorView)
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true;
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true;
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true;
        
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true;
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true;
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true;
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
