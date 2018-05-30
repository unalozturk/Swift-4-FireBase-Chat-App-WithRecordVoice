//
//  ChatLogController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Ünal Öztürk on 29.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
class ChatLogController : UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate {
    
    var cellId = "cellId"
    
    var user : user? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid , let toId = user?.id else{return}
        
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else{return}
            
                self.messages.append(Message(dictionary : dictionary))
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    //scroll to last index
                    let indexPath: IndexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath , at: .bottom, animated: true)
                }
                
                
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor  = .white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom:58 , right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom:8 , right: 0)
        collectionView?.translatesAutoresizingMaskIntoConstraints=false
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        //Keyboard will hide with swipe down
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.alwaysBounceVertical = true
        
        
        setupKeyboardObservers()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
       /* NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)*/
    }
    @objc func handleKeyboardDidShow(notification: NSNotification) {
        if  messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
       
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                
                self.containerViewBottomAnchor?.constant = -keyboardSize.height
                UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                    self.view.layoutIfNeeded()
                })
               
            }
            
        }
    }
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        if let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            
            self.containerViewBottomAnchor?.constant = 0
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainer = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainer.chatLogController = self
        return chatInputContainer
    }()
    
   
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var recordButton: UIButton!
    
    @objc func handleRecordVoice() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordTapped()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true, url: audioRecorder.url )
        }
    }
    
    func startRecording() {
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
           // recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false, url: nil)
        }
    }
    func finishRecording(success: Bool, url : URL?) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
           // recordButton.setTitle("Tap to Re-record", for: .normal)
            handleUploadRecordedVoice(url: url!)
            
        } else {
           // recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc func handleUploadImageTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a media
            handleVideoSelectedForUrl(url: videoUrl)
        }else {
             //we selected a picture
            handleImageSelectedForInfo(info: info)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    private func handleImageSelectedForInfo(info: [String:Any]){
        var selectedImageFromPicker:UIImage?
        
        if let editedImage =  info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            // profileImage.image = selectedImage
           // self.uploadToFireBaseStorageUsingImage(selectedImage: selectedImage)
            uploadToFireBaseStorageUsingImage(selectedImage: selectedImage, completion: { (imageURL) in
                self.sendMessageWithImageUrl(imageUrl: imageURL, image: selectedImage)
            })
        }
        
    }
    private func handleVideoSelectedForUrl(url : URL) {
        let fileName = NSUUID().uuidString + ".mov"
        let storeRef = Storage.storage().reference().child("messages_movies").child(fileName)
        let uploadTask = storeRef.putFile(from: url, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print("Failed upload of video:", error ?? "")
                return
            }
            
            storeRef.downloadURL(completion: { (videURL, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                if let thumbnailImage = self.thumbnailImageForVideoUrl(fileUrl: url) {
                    self.uploadToFireBaseStorageUsingImage(selectedImage: thumbnailImage, completion: { (imageUrl) in
                        let properties: [String:Any]  = ["imageUrl":imageUrl,"imageWidth": thumbnailImage.size.width,"imageHeight": thumbnailImage.size.height, "videoUrl": videURL?.absoluteString]
                        self.sendMessageWithProperties(properties: properties)
                        
                    })
                }
            })
            
           /* if let videoUrl = metadata?.downloadURL()?.absoluteString {
                
                if let thumbnailImage = self.thumbnailImageForVideoUrl(fileUrl: url) {
                    self.uploadToFireBaseStorageUsingImage(selectedImage: thumbnailImage, completion: { (imageUrl) in
                        let properties: [String:Any]  = ["imageUrl":imageUrl,"imageWidth": thumbnailImage.size.width,"imageHeight": thumbnailImage.size.height, "videoUrl": videoUrl]
                        self.sendMessageWithProperties(properties: properties)
                        
                    })
                }
            }*/
            
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
        
    }
    private func thumbnailImageForVideoUrl(fileUrl : URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
             let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        return nil
    }
    
    private func  uploadToFireBaseStorageUsingImage(selectedImage: UIImage, completion: @escaping (_ imageUrl: String) -> () )
    {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.2) {
            
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil { print("Failed to upload images",error ?? ""); return }
            
                ref.downloadURL(completion: { (imageUrl, error) in
                  //  if error != nil { print("Failed to upload images",error ?? ""); return }
                    if let imgUrl = imageUrl?.absoluteString {
                        completion(imgUrl)
                    }
                })
                /* if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                   // self.sendMessageWithImageUrl(imageUrl: imageUrl, image:selectedImage)
                }*/
            })
        }
    }
    
    private func handleUploadRecordedVoice(url : URL) {
        let fileName = NSUUID().uuidString + ".m4a"
        let storeRef = Storage.storage().reference().child("messages_records").child(fileName)
        
        let uploadTask = storeRef.putFile(from: url, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print("Failed upload of video:", error ?? "")
                return
            }
            
            storeRef.downloadURL(completion: { (videURL, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                let properties: [String:Any]  = ["imageUrl":"https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/12in-Vinyl-LP-Record-Angle.jpg/1200px-12in-Vinyl-LP-Record-Angle.jpg","imageWidth": "300","imageHeight": "300", "videoUrl": videURL?.absoluteString]
                self.sendMessageWithProperties(properties: properties)
            })
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
        
    }
   
    
    override var inputAccessoryView: UIView? {
        get {
          return inputContainerView
        }
    }
    override var canBecomeFirstResponder: Bool
    {
        return true
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self
        
        
        let message = messages[indexPath.row]
        cell.message = message
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        
        if let text = message.text {
             cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
             cell.textView.isHidden = false
        }else if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubbleWidthAnchor?.constant = 200
             cell.textView.isHidden = true
        }
        
        cell.playButton.isHidden = message.videoUrl == nil
       
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell , message: Message)
    {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.kf.setImage(with: URL(string:profileImageUrl))
           
        }
        
        if let messageImageUrl = message.imageUrl  {
            cell.messageImageView.kf.setImage(with:  URL(string:messageImageUrl))
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
            
        } else {
            cell.messageImageView.isHidden = true
        }
        
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = .white
            cell.bubbleRightAnchor?.isActive = true;
            cell.bubbleLeftAnchor?.isActive = false;
            cell.profileImageView.isHidden = true;
        }else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false;
            cell.bubbleRightAnchor?.isActive = false;
            cell.bubbleLeftAnchor?.isActive = true;
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 20
        }else if let imageHeight = message.imageHeight?.floatValue, let imageWidth = message.imageWidth?.floatValue {
            //h1 /w1 = h2 / w2
            //solve for h1
            //h1 = h2 / w1*w2
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text:String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    @objc func handleSend () {
        let properties: [String:Any]  = [ "text": inputContainerView.inputTextField.text ?? ""]
        sendMessageWithProperties(properties: properties)
    }
    private func sendMessageWithImageUrl(imageUrl: String,image: UIImage){
       let properties: [String:Any]  = [ "imageUrl": imageUrl,"imageWidth": image.size.width, "imageHeight": image.size.height]
       sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties: [String: Any] ){
        let ref  = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp: Any =  Int(Date().timeIntervalSince1970)
        
        var values: [String:Any] = ["toId": toId,"fromId": fromId,"timeStamp": timeStamp]
        
        properties.forEach({values[$0]=$1})
        
        
        childRef.updateChildValues(values) { (error, dataBaseReference) in
            if error != nil {
                print(error ?? "" )
                return
            }
            self.inputContainerView.inputTextField.text = ""
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId:1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId:1])
        }
        
    }
    
    
   
    
    
    var startingFrame: CGRect?
    var blackBackgroundView : UIView?
    var startingImageView : UIImageView?
    
    //My custom zoom logic
    func performZoomInForStartingImageView(startingImageView: UIImageView){
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow =  UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame:keyWindow.frame)
            blackBackgroundView?.alpha = 0
            blackBackgroundView?.backgroundColor = .black
            
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                //math?
                //h2 / w1 = h1 / w1
                //h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(tapGesture : UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }, completion: { (completed:Bool) in
                 zoomOutImageView.removeFromSuperview()
                 self.startingImageView?.isHidden = false
                
            })
        }
        print("Zoom out")
        
    }
}
