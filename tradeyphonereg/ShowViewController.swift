//
//  ShowViewController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-10.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase
class ShowViewController: UIViewController {

    var currentItem: Item!
    var currentItemId: String!
    var requests = [String]()
    var contactBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(home))
        navigationItem.title = currentItem.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contact", style: .Plain, target: self, action: #selector(contact))
        navigationItem.rightBarButtonItem?.enabled = contactBool
        productImage.loadImageUsingCacheWithUrlString(currentItem.itemImageUrl!)
        productDetails.text = currentItem.desc
        view.addSubview(productImage)
        view.addSubview(productDetails)
        view.addSubview(request)
        view.backgroundColor = UIColor.whiteColor()
        setupProductImage()
        setupProductDetails()
        setupRequestButton()
        if let user = FIRAuth.auth()?.currentUser {
            //signed in
            FIRDatabase.database().reference().child("users").child(user.uid).child("requests").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                    self.requests.append(snapshot.value as! String)
                }, withCancelBlock: nil)
        } else {
            //user is not authenticated
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        print(requests)
        for req in requests {
            FIRDatabase.database().reference().child("requests").child(req).observeEventType(.ChildAdded, withBlock: { (snapshot) in
                    if(snapshot.value as! String == self.currentItemId && snapshot.key == "toItem") {
                        print("found toItem")
                        FIRDatabase.database().reference().child("requests").child(req).observeEventType(.ChildAdded, withBlock: { (snapshotAccepted) in
                            // I cound't use req/accepted because we're pulling data, not setting values
                            if(snapshotAccepted.key == "accepted" && snapshotAccepted.value as! String == "true") {
                                print("found accepted")
                                print(snapshotAccepted.value)
                                self.contactBool = true
                                self.navigationItem.rightBarButtonItem?.enabled = self.contactBool
                            }
                            }, withCancelBlock: nil)
                    }
                }, withCancelBlock:nil)
        }
    }
    
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let productDetails: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(red:0.05, green:0.1, blue:0.15, alpha:1.0)
        label.font = label.font.fontWithSize(14)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    lazy var request: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(red:1.0, green:0.76, blue:0.0, alpha:1.0)
        button.setTitle("Request", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(createRequest), forControlEvents: .TouchUpInside)
        return button
    }()
    
    func createRequest() {
        if let user = FIRAuth.auth()?.currentUser {
            //signed in
            let requestController = RequestController()
            requestController.currentUser = user.uid
            requestController.toItemUserId = currentItem.userId
            requestController.toItemId = currentItemId
            let navcontroller = UINavigationController(rootViewController: requestController)
            self.presentViewController(navcontroller, animated: true, completion: nil)
            
        } else {
            print("user is not signed in/not authenticated")
        }
    }
    
    func contact() {
        let contactController = ContactController()
        contactController.userId = currentItem.userId
        let navController = UINavigationController(rootViewController: contactController)
        presentViewController(navController, animated: true, completion: nil)
    }

    
    func setupProductImage() {
        productImage.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        productImage.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 70).active = true
        productImage.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -7).active = true
        productImage.heightAnchor.constraintEqualToConstant(300).active = true
        
    }
    
    func setupProductDetails() {
        productDetails.topAnchor.constraintEqualToAnchor(productImage.bottomAnchor, constant: 5).active = true
        productDetails.leftAnchor.constraintEqualToAnchor(productImage.leftAnchor).active = true
        productDetails.rightAnchor.constraintEqualToAnchor(productImage.rightAnchor).active = true
    }
    
    func setupRequestButton() {
        //need x, y, width, height constraints
        request.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        request.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -7).active = true
        request.widthAnchor.constraintEqualToAnchor(productImage.widthAnchor).active = true
        request.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    func home() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
