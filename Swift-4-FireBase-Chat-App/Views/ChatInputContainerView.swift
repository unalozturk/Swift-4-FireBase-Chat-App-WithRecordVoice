//
//  ChatInputContainerView.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 6.04.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    var chatLogController : ChatLogController?  {
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadImageTap)))
            recordImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleRecordVoice(_:))))
        }
    }
    
    lazy var inputTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Text"
        tf.delegate = self
        return tf
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let uploadImageView: UIImageView = {
        var iView = UIImageView(image: UIImage(named: "upload_image_icon"))
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.contentMode = .scaleAspectFit
        //  iView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImageTap)))
        iView.isUserInteractionEnabled = true
        return iView
    }()
    
    let recordImageView: UIImageView = {
        var iView = UIImageView(image: UIImage(named: "mic"))
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.contentMode = .scaleAspectFit
        //  iView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImageTap)))
        iView.isUserInteractionEnabled = true
        return iView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        
        self.addSubview(uploadImageView)
        [
            uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            uploadImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 8),
            uploadImageView.widthAnchor.constraint(equalToConstant: 30),
            uploadImageView.heightAnchor.constraint(equalToConstant: 30)
            ].forEach {$0.isActive=true}
        
        self.addSubview(recordImageView)
        [
            recordImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            recordImageView.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor,constant: 8),
            recordImageView.widthAnchor.constraint(equalToConstant: 30),
            recordImageView.heightAnchor.constraint(equalToConstant: 30)
        ].forEach {$0.isActive=true}
        
        
        
        self.addSubview(sendButton)
        [
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: heightAnchor)
            ].forEach {$0.isActive=true}
        
        
        addSubview(self.inputTextField)
        [
            self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            self.inputTextField.leadingAnchor.constraint(equalTo: recordImageView.trailingAnchor, constant : 8),
            self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor)
            ].forEach {$0.isActive=true}
        
        let seperatorView: UIView = {
            let view =  UIView()
            view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
       addSubview(seperatorView)
        
        [
            seperatorView.bottomAnchor.constraint(equalTo: topAnchor),
            seperatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5),
            seperatorView.widthAnchor.constraint(equalTo:  widthAnchor)
            ].forEach {$0.isActive=true}
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
        return true
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
