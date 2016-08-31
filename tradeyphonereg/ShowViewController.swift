//
//  ShowViewController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-10.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase
class ShowViewController: UIViewController, UITextViewDelegate {

    var currentItem: Item!
    var currentItemId: String!
    var contactBool = false
    var requestBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(home))
        navigationItem.title = currentItem.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contact", style: .Plain, target: self, action: #selector(contact))
        navigationItem.rightBarButtonItem?.enabled = contactBool
        request.enabled = requestBool
        productImage.loadImageUsingCacheWithUrlString(currentItem.itemImageUrl!)
        let itemDate = NumToDateToStr(currentItem.timestamp!)
        print(currentItem.desc)
        productDetails.text = currentItem.desc
        print(productDetails.text)
        dateLabel.text = itemDate
        productTitle.text = currentItem.title
        view.addSubview(dateLabel)
        view.addSubview(productImage)
        view.addSubview(productDetails)
        view.addSubview(request)
        view.addSubview(lineseparator)
        view.addSubview(productTitle)
        view.backgroundColor = UIColor.whiteColor()
        request.backgroundColor = UIColor(red:1.0, green:0.76, blue:0.0, alpha:1.0)
        request.setTitle("Request", forState: .Normal)
        setupProductImage()
        setupRequestButton()
        setupDateLabel()
        setupLineSep()
        setupProductTitle()
        setupProductDetails()
        if let user = FIRAuth.auth()?.currentUser {
            //signed in
            //checking the current item shown is "my" item
            if user.uid == currentItem.userId {
                self.contactBool = false
                self.navigationItem.rightBarButtonItem?.enabled = self.contactBool
                self.requestBool = false
                self.request.enabled = self.requestBool
                self.request.setTitle("My Item", forState: .Normal)
                self.request.backgroundColor? = UIColor.grayColor()
            }  else {
            //checking if I(current user) requested the item in the show
            FIRDatabase.database().reference().child("users").child(user.uid).child("requests").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                            FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observeEventType(.ChildAdded, withBlock: { (snapshotChild) in
                                    //check if the item in the show page is requested by me(the current user) by any of my items
                                    if(snapshotChild.key == "toItem" && snapshotChild.value as! String == self.currentItemId) {
                                        print("found toItem")
                                        FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observeEventType(.ChildAdded, withBlock: { (snapshotAccepted) in
                                            // I cound't use req/accepted because we're pulling data, not setting values
                                            if(snapshotAccepted.key == "accepted" && snapshotAccepted.value as! String == "true") {
                                                print("found accepted")
                                                print(snapshotAccepted.value)
                                                self.contactBool = true
                                                self.navigationItem.rightBarButtonItem?.enabled = self.contactBool
                                                self.requestBool = false
                                                self.request.enabled = self.requestBool
                                                self.request.setTitle("Accepted", forState: .Normal)
                                                self.request.backgroundColor? = UIColor(red:0.15, green:0.83, blue:0.31, alpha:1.0)
                                            } else if(snapshotAccepted.key == "accepted"){
                                                print("found pending")
                                                self.requestBool = false
                                                self.request.enabled = self.requestBool
                                                self.request.setTitle("Pending", forState: .Normal)
                                                self.request.backgroundColor? = UIColor.grayColor()
                                            }
                                            }, withCancelBlock: nil)
                                    }
                                }, withCancelBlock:nil)
                }, withCancelBlock: nil)
                var one_iteration_only = 0
                FIRDatabase.database().reference().child("users").child(user.uid).child("requested").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                    FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observeEventType(.ChildAdded, withBlock: { (snapshotChild) in
                        //created one_iteration_only to solve the problem of one item requesting many items from the same user, and the user should see accepted when he/she clicks on the item that the user requested from.
                        if(snapshotChild.key == "fromItem" && snapshotChild.value as! String == self.currentItemId) {
                            print("found from item before one_iteration")
                                print("found fromItem")
                                FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observeEventType(.ChildAdded, withBlock: { (snapshotAccepted) in
                                    // I cound't use req/accepted because we're pulling data, not setting values
                                    one_iteration_only = one_iteration_only + 1
                                    print(one_iteration_only)
                                    if (one_iteration_only == 1) {

                                        if(snapshotAccepted.key == "accepted" && snapshotAccepted.value as! String == "true") {
                                            print("found accepted")
                                            print(snapshotAccepted.value)
                                            self.contactBool = true
                                            self.navigationItem.rightBarButtonItem?.enabled = self.contactBool
                                            self.requestBool = false
                                            self.request.enabled = self.requestBool
                                            self.request.setTitle("Accepted ", forState: .Normal)
                                            self.request.backgroundColor? = UIColor(red:0.15, green:0.83, blue:0.31, alpha:1.0)
                                        } else if(snapshotAccepted.key == "accepted") {
                                            print("found pending")
                                            self.contactBool = false
                                            self.navigationItem.rightBarButtonItem?.enabled = self.contactBool
                                            self.requestBool = false
                                            self.request.enabled = self.requestBool
                                            self.request.setTitle("Pending ", forState: .Normal)
                                            self.request.backgroundColor? = UIColor.grayColor()
                                            //just to give the accepted a priority
                                            one_iteration_only = 0
                                        } else {
                                            one_iteration_only = 0
                                        }
                                    }
                                }, withCancelBlock: nil)
                            }
                        }, withCancelBlock:nil)
                    }, withCancelBlock: nil)
            }
        } else {
            //user is not authenticated
        }
        // Do any additional setup after loading the view.
    }
    
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var productDetails: UITextView = {
       let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(white:0.1, alpha:1.0)
        label.backgroundColor = UIColor(white:0.9, alpha:1.0)
        label.editable = false
        return label
    }()
    
    lazy var request: UIButton = {
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(createRequest), forControlEvents: .TouchUpInside)
        return button
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(white:0.38, alpha:1.0)
        label.font = UIFont(name: "Helvetica Neue", size: 12)
        label.sizeToFit()
        return label
    }()
    
    func setupDateLabel() {
        dateLabel.topAnchor.constraintEqualToAnchor(productImage.bottomAnchor, constant: 10).active = true
        dateLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 8).active = true
    }
    
    let lineseparator: UIView = {
        let horline = UIView()
        horline.backgroundColor = UIColor.blackColor()
        horline.translatesAutoresizingMaskIntoConstraints = false
        return horline
    }()
    
    func setupLineSep() {
        lineseparator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        lineseparator.heightAnchor.constraintEqualToConstant(0.5).active = true
        lineseparator.topAnchor.constraintEqualToAnchor(dateLabel.bottomAnchor, constant: 5).active = true
    }
    
    let productTitle: UILabel = {
       let label = UILabel()
        label.font = UIFont(name:"Helvetica Neue", size: 18)
        label.textColor = UIColor.blackColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupProductTitle() {
        productTitle.topAnchor.constraintEqualToAnchor(lineseparator.bottomAnchor, constant: 30).active = true
        productTitle.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 20).active = true
        productTitle.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
    }
    
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
        productDetails.topAnchor.constraintEqualToAnchor(productTitle.bottomAnchor, constant: 10).active = true
        productDetails.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 20).active = true
        productDetails.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -20).active = true
        productDetails.heightAnchor.constraintEqualToConstant(70).active = true
        productDetails.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
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
    
    func NumToDateToStr(date: NSNumber) -> String {
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let NumToDate = NSDate(timeIntervalSinceReferenceDate: date as Double)
        
        let myddate = dateformatter.stringFromDate(NumToDate)
        
        return myddate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}
