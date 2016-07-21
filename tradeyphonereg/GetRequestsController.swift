//
//  GetRequestsController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-17.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase

class GetRequestsController: UITableViewController {

    var myRequested = [String]()
    var toItems = [Item]()
    var fromItems = [Item]()
    let cellId = "RequestCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(home))
        tableView.registerClass(RequestCell.self, forCellReuseIdentifier: cellId)
        if let user = FIRAuth.auth()?.currentUser {
            //signed in
            FIRDatabase.database().reference().child("users").child(user.uid).child("requested").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                    self.myRequested.append(snapshot.value as! String)
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.tableView.reloadData()
//                    })
                FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observeEventType(.ChildAdded, withBlock: { (snapshotChild) in
                    print("here bitch")
                    if(snapshotChild.key == "fromItem") {
                        let item = Item()
                        FIRDatabase.database().reference().child("items").child(snapshotChild.value as! String).observeEventType(.ChildAdded, withBlock: { (snapshotChildItem) in
                            print("inside item requested")
                            //hacky way of setting the keys in item, becuase snapshot gives one key at a time inside the item's key
                            if(snapshotChildItem.key == "title") {
//                                print(snapshotChildItem.value as! String)
                                item.title = snapshotChildItem.value as! String
                            } else if(snapshotChildItem.key == "description") {
//                                print(snapshotChildItem.value as! String)
                                item.desc = snapshotChildItem.value as! String
                            } else if(snapshotChildItem.key == "imageUrl") {
//                                print(snapshotChildItem.value as! String)
                                item.itemImageUrl = snapshotChildItem.value as! String
                            } else if(snapshotChildItem.key == "userId") {
//                                print(snapshotChildItem.value as! String)
                                item.userId = snapshotChildItem.value as! String
                            }
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.tableView.reloadData()
                                })
                            }, withCancelBlock: nil)
                        self.fromItems.append(item)
                    } else if(snapshotChild.key == "toItem") {
                        let item = Item()
                        FIRDatabase.database().reference().child("items").child(snapshotChild.value as! String).observeEventType(.ChildAdded, withBlock: { (snapshotChildItem) in
                            print("inside item requests")
                            //hacky way of setting the keys in item, becuase snapshot gives one key at a time inside the item's key
                            if(snapshotChildItem.key == "title") {
                                                                print(snapshotChildItem.value as! String)
                                item.title = snapshotChildItem.value as! String
                            } else if(snapshotChildItem.key == "description") {
                                                                print(snapshotChildItem.value as! String)
                                item.desc = snapshotChildItem.value as! String
                            } else if(snapshotChildItem.key == "imageUrl") {
                                                                print(snapshotChildItem.value as! String)
                                item.itemImageUrl = snapshotChildItem.value as! String
                            } else if(snapshotChildItem.key == "userId") {
                                                                print(snapshotChildItem.value as! String)
                                item.userId = snapshotChildItem.value as! String
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableView.reloadData()
                            })
                            }, withCancelBlock: nil)
                        self.toItems.append(item)
                    }
                    
                    }, withCancelBlock: nil)
                }, withCancelBlock: nil)

        } else {
            //not authenticated
        }
        
    }

    func home() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("hey dick")
        print(fromItems)
        print(toItems)
        return fromItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! RequestCell
        print("hey dick2")
        cell.textLabel?.text = fromItems[indexPath.row].title
        cell.detailTextLabel?.text = fromItems[indexPath.row].desc
        if let imageUrlLeft = fromItems[indexPath.row].itemImageUrl {
            cell.itemImageViewLeft.loadImageUsingCacheWithUrlString(imageUrlLeft)
        }
        if let imageUrlRight = toItems[indexPath.row].itemImageUrl {
            cell.itemImageViewRight.loadImageUsingCacheWithUrlString(imageUrlRight)
        }
        
        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(accept), forControlEvents: .TouchUpInside)
        cell.declineButton.addTarget(self, action: #selector(decline), forControlEvents: .TouchUpInside)
        // Configure the cell...
        
        return cell
    }
    
    func accept(sender:UIButton) {
        let buttonRow = sender.tag
        print(buttonRow)
        print(myRequested)
        let ref = FIRDatabase.database().referenceFromURL("https://tradey2-0.firebaseio.com/")
        let requestAccepted = FIRDatabase.database().reference().child("requests").child(myRequested[buttonRow]+"/accepted")
        requestAccepted.setValue("true")
        print("TRUE")
    }
 
    func decline(sender:UIButton) {
        let buttonRow = sender.tag
        //nothing todo since the request is already false, in the future will delete request
        print("FALSE")
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    

}

class RequestCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(86, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRectMake(86 , detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    
    let itemImageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let itemImageViewRight: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Checkmark-30")
        button.setImage(image, forState: .Normal)
//        button.addTarget(self, action: #selector(accept), forControlEvents: .TouchUpInside)
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Cancel-30")
        button.setImage(image, forState: .Normal)
//        button.addTarget(self, action: #selector(decline), forControlEvents: .TouchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageViewLeft)
        addSubview(itemImageViewRight)
        addSubview(acceptButton)
        addSubview(declineButton)
        
        itemImageViewLeft.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        itemImageViewLeft.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        itemImageViewLeft.widthAnchor.constraintEqualToConstant(70).active = true
        itemImageViewLeft.heightAnchor.constraintEqualToConstant(70).active = true
        
        itemImageViewRight.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8).active = true
        itemImageViewRight.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        itemImageViewRight.widthAnchor.constraintEqualToConstant(70).active = true
        itemImageViewRight.heightAnchor.constraintEqualToConstant(70).active = true
        
        acceptButton.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        acceptButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor, constant: 25).active = true
        acceptButton.widthAnchor.constraintEqualToConstant(50).active = true
        acceptButton.heightAnchor.constraintEqualToConstant(50).active = true
        
        declineButton.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        declineButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor, constant: 70).active = true
        declineButton.widthAnchor.constraintEqualToConstant(50).active = true
        declineButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

