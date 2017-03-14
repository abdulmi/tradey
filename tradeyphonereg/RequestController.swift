//
//  RequestController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-15.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase

class RequestController: UITableViewController {

    var currentUser: String!
    var itemsIds = [String]()
    var items = [Item]()
    var toItemId: String!
    var toItemUserId: String!
    let cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToShow))
        // Do any additional setup after loading the view.
        tableView.register(ItemCell.self, forCellReuseIdentifier: cellId)
        print("inside requestcontroller")
        print(currentUser)
        FIRDatabase.database().reference().child("users").child(currentUser).child("items").observe(.childAdded, with: { (snapshot) in
                print(snapshot.value)
                self.itemsIds.append(snapshot.value as! String)
            }, withCancel: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchItems()
        print("how many items")
        print(items)
    }
    func backToShow() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchItems() {
        print("itemids count is 0")
        print(itemsIds)
        for itemId in itemsIds {
            let item = Item()
            FIRDatabase.database().reference().child("items").child(itemId).observe(.childAdded, with: { (snapshot) in
                //hacky way of setting the keys in item, becuase snapshot gives one key at a time inside the item's key 
                if(snapshot.key == "title") {
                    item.title = snapshot.value as! String
                } else if(snapshot.key == "description") {
                    item.desc = snapshot.value as! String
                } else if(snapshot.key == "imageUrl") {
                    item.itemImageUrl = snapshot.value as! String
                } else if(snapshot.key == "userId") {
                    item.userId = snapshot.value as! String
                } else if(snapshot.key == "timestamp") {
                    item.timestamp = snapshot.value as! NSNumber
                } else if(snapshot.key == "category") {
                    item.category = snapshot.value as! String
                }
                
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                
                
                }, withCancel: nil)
            self.items.append(item)

        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to choose " + items[indexPath.row].title! + "?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("ALERT")
            let ref = FIRDatabase.database().reference(fromURL: "https://tradey2-0.firebaseio.com/")
            let requestRef = ref.child("requests").childByAutoId()
            let content = ["fromItem": self.itemsIds[indexPath.row], "toItem": self.toItemId, "fromUser": self.currentUser, "toUser": self.toItemUserId, "accepted": "false"]
            requestRef.setValue(content)
            let userRequestRef = ref.child("users").child(self.currentUser).child("requests").childByAutoId()
            userRequestRef.setValue(requestRef.key)
            let userRequestedRef = ref.child("users").child(self.toItemUserId).child("requested").childByAutoId()
            userRequestedRef.setValue(requestRef.key)
            self.dismiss(animated: true, completion: nil)
            print("cell selected")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("NO")
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        
//        let ref = FIRDatabase.database().referenceFromURL("https://tradey2-0.firebaseio.com/")
//        let requestRef = ref.child("requests").childByAutoId()
//        let content = ["fromItem": itemsIds[indexPath.row], "toItem": toItemId, "fromUser": currentUser, "toUser": toItemUserId, "accepted": "false"]
//        requestRef.setValue(content)
//        let userRequestRef = ref.child("users").child(currentUser).child("requests").childByAutoId()
//        userRequestRef.setValue(requestRef.key)
//        let userRequestedRef = ref.child("users").child(toItemUserId).child("requested").childByAutoId()
//        userRequestedRef.setValue(requestRef.key)
//        dismissViewControllerAnimated(true, completion: nil)
//        print("cell selected")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell view")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.desc
        print(item.title)
        print(item.desc)
        print(item.itemImageUrl)
        print(item.userId)
        print(item.timestamp)
        print(item.category)
        
        if let imageUrl = item.itemImageUrl {
            cell.itemImageView.loadImageUsingCacheWithUrlString(imageUrl)
        }
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}
