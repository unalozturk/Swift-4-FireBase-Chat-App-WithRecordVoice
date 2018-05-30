//
//  LoginController+handler.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 29.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    @objc func handleRegister() {
        guard let email = emailTextField.text, let passwordd = passwordTextField.text , let name = nameTextField.text else {
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: passwordd) { (nil, error) in
            if error != nil
            {
                print(error  ?? "")
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else{return}
            let storeRef = Storage.storage().reference().child("profile_images").child("\(uid).png")
            
            //upload photo
            
            
            if let profileImage=self.profileImage.image,let uploadData = UIImageJPEGRepresentation(profileImage,0.1){
                storeRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    
                    
                    storeRef.downloadURL(completion: { (profileURL, error) in
                        if error != nil {
                            print(error ?? "")
                            return
                        }
                        if let profileImageUrl = profileURL?.absoluteString {
                            let values = ["name":name , "email": email , "profileImageUrl":profileImageUrl ]
                            self.registerUserDatabaseWithUID(uid: uid, values:values)
                        }
                    })
                   /* if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name":name , "email": email , "profileImageUrl":profileImageUrl ]
                        self.registerUserDatabaseWithUID(uid: uid, values:values)
                    }*/
                    
                })
            }
            
            
            
            
            
           
        }
        
    }
    
    private func registerUserDatabaseWithUID(uid:String, values : [String:String]) {
        //successfully auth
        let ref = Database.database().reference()
       // let values = ["name":name, "email": email, "profieImageUrl"]
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values) { (error, ref) in
            if error != nil
            {
                print(error ?? "")
                return
            }
        
            //self.messagesController?.navigationItem.title = values["name"]
            let user_ = user()
            user_.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user_)
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker:UIImage?
        
        if let editedImage =  info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
