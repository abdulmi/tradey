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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(backToShow))
        // Do any additional setup after loading the view.
        tableView.registerClass(ItemCell.self, forCellReuseIdentifier: cellId)
        print("inside requestcontroller")
        print(currentUser)
        FIRDatabase.database().reference().child("users").child(currentUser).child("items").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                print(snapshot.value)
                self.itemsIds.append(snapshot.value as! String)
            }, withCancelBlock: nil)
    }
    override func viewDidAppear(animated: Bool) {
        fetchItems()
        print("how many items")
        print(items)
    }
    func backToShow() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchItems() {
        print("itemids count is 0")
        print(itemsIds)
        for itemId in itemsIds {
            let item = Item()
            FIRDatabase.database().reference().child("items").child(itemId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
                //hacky way of setting the keys in item, becuase snapshot gives one key at a time inside the item's key 
                if(snapshot.key == "title") {
                    item.title = snapshot.value as! String
                } else if(snapshot.key == "description") {
                    item.desc = snapshot.value as! String
                } else if(snapshot.key == "imageUrl") {
                    item.itemImageUrl = snapshot.value as! String
                } else if(snapshot.key == "userId") {
                    item.userId = snapshot.value as! String
                }
                
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                
                
                }, withCancelBlock: nil)
            self.items.append(item)

        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        let ref = FIRDatabase.database().referenceFromURL("https://tradey2-0.firebaseio.com/")
        let requestRef = ref.child("requests").childByAutoId()
        let content = ["fromItem": itemsIds[indexPath.row], "toItem": toItemId, "fromUser": currentUser, "toUser": toItemUserId, "accepted": "false"]
        requestRef.setValue(content)
        let userRequestRef = ref.child("users").child(currentUser).child("requests").childByAutoId()
        userRequestRef.setValue(requestRef.key)
        let userRequestedRef = ref.child("users").child(toItemUserId).child("requested").childByAutoId()
        userRequestedRef.setValue(requestRef.key)
        dismissViewControllerAnimated(true, completion: nil)
        print("cell selected")
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cell view")
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.desc
        print(item.title)
        print(item.desc)
        print(item.itemImageUrl)
        print(item.userId)
        
        if let imageUrl = item.itemImageUrl {
            cell.itemImageView.loadImageUsingCacheWithUrlString(imageUrl)
        }
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
}
