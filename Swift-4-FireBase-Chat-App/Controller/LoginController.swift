//
//  LoginControllerViewController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 28.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit

import Firebase

class LoginController: UIViewController {
    
    var messagesController: MessagesViewController?
    
    let inputContainerView : UIView =  {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else {
            handleRegister()
        }
        
    }
    @objc func handleLogin() {
        guard let email = emailTextField.text, let passwordd = passwordTextField.text  else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: passwordd) { (_, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            self.messagesController?.fetchUserAndSetupNavBarTitle();
            self.dismiss(animated: true, completion: nil)
        }
       
       /* Auth.auth().signIn(withEmail: email, password: passwordd) { (user : User?, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            self.messagesController?.fetchUserAndSetupNavBarTitle();
            self.dismiss(animated: true, completion: nil)
        }*/
        
    }
    
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name";
        return tf
    }()
    
    let nameSeperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 200)
        return view
    }()

    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        return tf
    }()
    
    let emailSeperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 220, g: 220, b: 200)
        return view
    }()
    
    let  passwordTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.isSecureTextEntry=true
        return tf
    }()
    
    lazy var profileImage : UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        imgv.image = UIImage(named: "got")
        imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imgv.isUserInteractionEnabled = true
        return imgv
    }()
    
   
    
    let loginRegisterSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImage)
        view.addSubview(loginRegisterSegmentedControl)
       
        
        setupInputContainerView()
        setupLoginRegisterButton()
        setupProfileImage()
        setupSegmentedControl()
        
       
        
    }
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        
        //change height of inputContainerView
        inputContainerViewHeightAnchor.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of nameTextField
        nameTextFieldHeightAnchor.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/3 )
        nameTextFieldHeightAnchor.isActive = true
        
        passwordTextFieldHeightAnchor.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3 )
        passwordTextFieldHeightAnchor.isActive = true
        
        mailTextFieldHeightAnchor.isActive = false
        mailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3 )
        mailTextFieldHeightAnchor.isActive = true
    }
    
    var inputContainerViewHeightAnchor : NSLayoutConstraint!
    var nameTextFieldHeightAnchor : NSLayoutConstraint!
    var mailTextFieldHeightAnchor : NSLayoutConstraint!
    var passwordTextFieldHeightAnchor : NSLayoutConstraint!
    
    func setupInputContainerView() {
        
      /* if #available(iOS 11, *) {
            inputContainerViewHeightAnchor =  inputContainerView.heightAnchor.constraint(equalToConstant: 150)
            [
                inputContainerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                inputContainerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                inputContainerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -24),
                inputContainerViewHeightAnchor
                
                ].forEach { $0.isActive=true}
        }else
        {*/
            inputContainerViewHeightAnchor =  inputContainerView.heightAnchor.constraint(equalToConstant: 150)
            [
                inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24),
                inputContainerViewHeightAnchor
                
                ].forEach { $0.isActive=true}
      //  }
        
        
        
        inputContainerView.addSubview(nameTextField)
        
        nameTextFieldHeightAnchor =  nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3, constant: 0)
        [
            nameTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            nameTextFieldHeightAnchor
          ].forEach { $0.isActive=true}
        
        inputContainerView.addSubview(nameSeperatorView)
        
        [
            nameSeperatorView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            nameSeperatorView.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            nameSeperatorView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeperatorView.heightAnchor.constraint(equalToConstant:0.5)
        ].forEach { $0.isActive=true}
        
        
        ////
        inputContainerView.addSubview(emailTextField)
        
        mailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3, constant: 0)
        [
            emailTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor),
            mailTextFieldHeightAnchor
        ].forEach { $0.isActive=true}
        
        inputContainerView.addSubview(emailSeperatorView)
        
        [
            emailSeperatorView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            emailSeperatorView.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            emailSeperatorView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailSeperatorView.heightAnchor.constraint(equalToConstant:0.5)
        ].forEach { $0.isActive=true}
        
        ////
        inputContainerView.addSubview(passwordTextField)
        
        passwordTextFieldHeightAnchor =  passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3, constant: 0)
        [
            passwordTextField.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor),
            passwordTextFieldHeightAnchor
        ].forEach { $0.isActive=true}
        
        
        
    }
    
    func setupLoginRegisterButton() {
      /*  if #available(iOS 11, *) {
            [
                loginRegisterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                loginRegisterButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -24),
                loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12),
                loginRegisterButton.heightAnchor.constraint(equalToConstant:50)
            ].forEach { $0.isActive=true}
        }else {*/
            [
                loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24),
                loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12),
                loginRegisterButton.heightAnchor.constraint(equalToConstant:50)
                ].forEach { $0.isActive=true}
            
       // }
    }
    
    func setupProfileImage() {
        /*if #available(iOS 11, *) {
            [
                profileImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                profileImage.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12),
                profileImage.widthAnchor.constraint(equalToConstant:150),
                profileImage.heightAnchor.constraint(equalToConstant:150)
            ].forEach { $0.isActive=true}
        }else
        {*/
            [
                profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                profileImage.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12),
                profileImage.widthAnchor.constraint(equalToConstant:150),
                profileImage.heightAnchor.constraint(equalToConstant:150)
            ].forEach { $0.isActive=true}
            
       // }
        
    }
    
    func setupSegmentedControl() {
      /*  if #available(iOS 11, *) {
            [
                loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12),
                loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
                loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36)
            ].forEach { $0.isActive=true}
        }else
        {*/
            [
                loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12),
                loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
                loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36)
            ].forEach { $0.isActive=true}
       // }
    }

}
extension UIColor {
    convenience init(r:CGFloat, g:CGFloat , b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
