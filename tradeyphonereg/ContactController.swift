//
//  ContactController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-16.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase
class ContactController: UITableViewController {
    var cellId = "ContactCell"
    var contactKeys = ["name","phone","email"]
    var contactList = ["email": "","phone": "","name": ""]
    var contactPhotos = ["Circled User Male-50","Phone-50", "Message-52"]
    var userId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.registerClass(ContactCell.self, forCellReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(home))
        FIRDatabase.database().reference().child("users").child(userId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if(snapshot.key != "items" && snapshot.key != "requests" && snapshot.key != "requested") {
                self.contactList[snapshot.key] = snapshot.value as! String
            }
            }, withCancelBlock: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        print(contactList)
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 1) {
            callNumber(contactList["phone"]!)
        } else if(indexPath.row == 2) {
            let email = contactList["email"]
            print(contactList["email"])
            let url = NSURL(string: "mailto:" + email!)!
            UIApplication.sharedApplication().openURL(url)
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ContactCell
        cell.textLabel?.text = contactKeys[indexPath.row]
        cell.detailTextLabel?.text = contactList[contactKeys[indexPath.row]]
        print(contactList)
        cell.itemImageView.image = UIImage(named: contactPhotos[indexPath.row])
        // Configure the cell..

        return cell
    }

    func home() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
}

class ContactCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(86, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRectMake(86 , detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageView)
        
        itemImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        itemImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        itemImageView.widthAnchor.constraintEqualToConstant(40).active = true
        itemImageView.heightAnchor.constraintEqualToConstant(40).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



