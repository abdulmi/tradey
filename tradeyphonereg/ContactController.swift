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
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(home))
        FIRDatabase.database().reference().child("users").child(userId).observe(.childAdded, with: { (snapshot) in
            if(snapshot.key != "items" && snapshot.key != "requests" && snapshot.key != "requested") {
                self.contactList[snapshot.key] = snapshot.value as! String
            }
            }, withCancel: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        print(contactList)
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 1) {
            callNumber(contactList["phone"]!)
        } else if(indexPath.row == 2) {
            let email = contactList["email"]
            print(contactList["email"])
            let url = URL(string: "mailto:" + email!)!
            UIApplication.shared.openURL(url)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        cell.textLabel?.text = contactKeys[indexPath.row]
        cell.detailTextLabel?.text = contactList[contactKeys[indexPath.row]]
        print(contactList)
        cell.itemImageView.image = UIImage(named: contactPhotos[indexPath.row])
        // Configure the cell..

        return cell
    }

    func home() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func callNumber(_ phoneNumber:String) {
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

class ContactCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 86, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 86 , y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageView)
        
        itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



