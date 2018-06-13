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
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton : UIButton =
    {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.SpotKingColors.lightGreen
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLoginRegister()
    {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0
        {
            handleLogin()
        }
        else
        {
            handleRegister()
        }
    }
    
    func handleLogin()
    {
        guard let email = emailTextField.text,let password = passwordTextField.text else
        {
            return
        }
        
        DatabaseManager.handleLogin(email: email, password: password)
        {
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleRegister()
    {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = usernameTextField.text else
        {
            print("Invalid Form")
            return
        }
        
        DatabaseManager.handleRegister(username: name, email: email, password: password) {
            
            //Success!
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let loginRegisterSegmentedControl:UISegmentedControl =
    {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor  = UIColor.SpotKingColors.lightGreen
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return sc
    }()
    
    let logoImageView : UIImageView =
    {
        let imageView = UIImageView(image: UIImage(named: "crown2"))
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel : UILabel =
    {
        let label = UILabel()
        label.text = "Spot King"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
      //  label.font = UIFont.boldSystemFont(ofSize: 44);

        label.font = UIFont(name: "Pacific Again", size: 60)
        label.textColor = UIColor.SpotKingColors.lightGreen;
        return label
    }()
    
    let usernameTextField : UITextField =
    {
        let textField = UITextField()
      //  textField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.placeholder = "username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let usernameSeperatorView : UIView =
    {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.SpotKingColors.lightGreen
        return view
    }()
    
    let emailTextField : UITextField =
    {
        let textField = UITextField()
       // textField.attributedPlaceholder = NSAttributedString(string: "e-mail", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.placeholder = "e-mail"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeperatorView : UIView =
    {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.SpotKingColors.lightGreen
        return view
    }()
    
    let passwordTextField : UITextField =
    {
        let textField = UITextField()
      //  textField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        textField.placeholder = "password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        setUpInputContainerView()
        setUpLoginButton()
        setUpTitle()
        setUpLoginRegisterSegmentedControl()
    }
    
    func setUpLoginRegisterSegmentedControl()
    {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor,constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setUpTitle()
    {
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
        
        let logo = UIImage(named: "crown2")
        let tintedImage = logo?.withRenderingMode(.alwaysTemplate)
        logoImageView.image = tintedImage
        logoImageView.tintColor = UIColor.SpotKingColors.lightGreen
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -2).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true;
        logoImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -24).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -24).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true;
    }
    
    func setUpLoginButton()
    {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var usernameTextFieldHeightAnchor:NSLayoutConstraint?
    var emailTextFieldHeightAnchor:NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:NSLayoutConstraint?

    func setUpInputContainerView()
    {
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true;
        //inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true;
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150);
        inputContainerViewHeightAnchor?.isActive = true;
        
        inputContainerView.addSubview(usernameTextField)
        usernameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true;
        usernameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true;
        usernameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        usernameTextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        usernameTextFieldHeightAnchor?.isActive = true;
        
        inputContainerView.addSubview(usernameSeperatorView)
        usernameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true;
        usernameSeperatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true;
        usernameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        usernameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true;
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true;
        emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true;
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(emailSeperatorView)
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true;
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true;
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true;
        
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true;
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true;
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true;
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    @objc func handleLoginRegisterChanged()
    {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        

        usernameTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor?.isActive = false
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0
        {
            //configure login view
            inputContainerViewHeightAnchor?.constant = 100
            usernameTextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier:0)
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier:0.5)
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier:0.5)
            usernameSeperatorView.isHidden = true
        }
        else
        {
            inputContainerViewHeightAnchor?.constant = 150
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier:1/3)
            usernameTextFieldHeightAnchor = usernameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier:1/3)
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier:1/3)
            usernameSeperatorView.isHidden = false
            //configure register view
        }
        
        usernameTextFieldHeightAnchor?.isActive = true
        emailTextFieldHeightAnchor?.isActive = true
        passwordTextFieldHeightAnchor?.isActive = true
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
       static let lightBlue = UIColor.init(r:0,g:137,b:249)
       static let yellow = UIColor.init(r:255,g:240,b:124)
       static let cyan = UIColor.init(r:89,g:248,b:232)
       static let begonia = UIColor.init(r:255,g:105,b:120)
    }
}
