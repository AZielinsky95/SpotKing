//
//  MessageController.swift
//  SpotKing
//
//  Created by Alejandro Zielinsky on 2018-06-09.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

import UIKit

class MessageController: UITableViewController {

    let cellID = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        DatabaseManager.fetchUsers { (users) in
                self.users = users
                for user in users
                {
                    DatabaseManager.downloadProfileImage(userID: user.userID!, completion: { (img) in
                         DispatchQueue.main.async
                        {
                            user.userImage = img
                            self.tableView.reloadData()
                        }
                    })
                }
        }
    }
    
    @objc func handleCancel()
    {
        dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? UserCell
        
        let user = users[indexPath.row]
        cell?.textLabel?.text = user.name
        cell?.profileImageView.image = user.userImage
        
        return cell!
    }
    
    var mapViewController : MapViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
          let user = self.users[indexPath.row]
          self.mapViewController?.showChatControllerForUser(user: user)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

}
