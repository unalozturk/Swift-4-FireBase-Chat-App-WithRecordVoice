//
//  ChatMessageCell.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 30.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController : ChatLogController?
    var message : Message?
    
   
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleLeftAnchor : NSLayoutConstraint?
    var bubbleRightAnchor : NSLayoutConstraint?
    
    let activityIndicatorView : UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named:"play"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @objc func handlePlay() {
        if let videoUrlString = message?.videoUrl, let url =  URL(string: videoUrlString) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    let textView: UITextView = {
       let tv = UITextView()
       tv.font = UIFont.systemFont(ofSize: 16)
     //  tv.textAlignment = .center
       tv.backgroundColor = .clear
       tv.textColor = .white
       tv.translatesAutoresizingMaskIntoConstraints = false
       tv.isEditable = false
       return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer){
        print("handling zoom")
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
              self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
        
        
    
      
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant:200)
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 8)
        [
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),
            bubbleWidthAnchor!,
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ].forEach { $0.isActive=true}
        
        
        addSubview(textView)
        [
            textView.leftAnchor.constraint(equalTo: self.bubbleView.leftAnchor,constant: 8),
            textView.topAnchor.constraint(equalTo: self.bubbleView.topAnchor),
            textView.bottomAnchor.constraint(equalTo:self.bubbleView.bottomAnchor),
            textView.rightAnchor.constraint(equalTo: self.bubbleView.rightAnchor)
        ].forEach { $0.isActive=true}
        
        addSubview(profileImageView)
        [
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 8),
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ].forEach { $0.isActive=true}
        
        
       bubbleView.addSubview(messageImageView)
       [
            messageImageView.topAnchor.constraint(equalTo: self.bubbleView.topAnchor),
            messageImageView.bottomAnchor.constraint(equalTo: self.bubbleView.bottomAnchor),
            messageImageView.trailingAnchor.constraint(equalTo: self.bubbleView.trailingAnchor),
            messageImageView.leadingAnchor.constraint(equalTo: self.bubbleView.leadingAnchor)
       ].forEach { $0.isActive=true}
        
       bubbleView.addSubview(playButton)
       [
            playButton.centerXAnchor.constraint(equalTo: self.bubbleView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: self.bubbleView.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 50)
        ].forEach { $0.isActive=true}
        
        
        bubbleView.addSubview(activityIndicatorView)
        [
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.bubbleView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.bubbleView.centerYAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50)
        ].forEach { $0.isActive=true}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
