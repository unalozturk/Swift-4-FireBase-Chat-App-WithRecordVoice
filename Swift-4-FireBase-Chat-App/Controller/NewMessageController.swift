//
//  NewMessageController.swift
//  Swift-4-FireBase-Chat-App
//
//  Created by Technoface on 29.03.2018.
//  Copyright © 2018 Technoface. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [user]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        self.tableView.register(Usercell.self, forCellReuseIdentifier: cellId)
        
        
        fetchUser()
       
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String:Any]{
                let user_ = user()
                user_.setValuesForKeys(dictionary)
                user_.id = snapshot.key
             /*   //Be careful dictionary names set as ur object
                user_.name = dictionary["name"] as? String
                user_.email = dictionary["email"] as? String
                user_.profileImageUrl = dictionary["profileImageUrl"] as? String*/
                print(user_.name ?? "",user_.email ?? "")
                
                self.users.append(user_)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }

    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    var messagesController = MessagesViewController()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        let user_ = users[indexPath.row]
        messagesController.showChatControllerForUser(user: user_)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! Usercell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            
            let url = URL(string: profileImageUrl)
            cell.profileImageView.kf.setImage(with: url!)
           /* URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data!)
                }
                
            }).resume()*/
           
        
        }
        //cell.imageView?.image =
        return cell
    }
    

}


