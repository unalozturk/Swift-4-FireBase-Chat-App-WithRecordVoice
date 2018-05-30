//
//  Message.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 30.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import FirebaseAuth

@objcMembers
class Message: NSObject {
    var fromId: String?
    var text : String?
    var timeStamp: NSNumber?
    var toId:String?
    var imageUrl : String?
    var imageHeight :NSNumber?
    var imageWidth : NSNumber?
    var videoUrl : String?

    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    init(dictionary : [String:Any]) {
        super.init()
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timeStamp = dictionary["timeStamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
       
    }
}
