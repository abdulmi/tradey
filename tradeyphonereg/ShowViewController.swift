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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(home))
        navigationItem.title = currentItem.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Contact", style: .plain, target: self, action: #selector(contact))
        navigationItem.rightBarButtonItem?.isEnabled = contactBool
        request.isEnabled = requestBool
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
        view.backgroundColor = UIColor.white
        request.backgroundColor = UIColor(red:1.0, green:0.76, blue:0.0, alpha:1.0)
        request.setTitle("Request", for: UIControlState())
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
                self.navigationItem.rightBarButtonItem?.isEnabled = self.contactBool
                self.requestBool = false
                self.request.isEnabled = self.requestBool
                self.request.setTitle("My Item", for: UIControlState())
                self.request.backgroundColor? = UIColor.gray
            }  else {
            //checking if I(current user) requested the item in the show
            FIRDatabase.database().reference().child("users").child(user.uid).child("requests").observe(.childAdded, with: { (snapshot) in
                            FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observe(.childAdded, with: { (snapshotChild) in
                                    //check if the item in the show page is requested by me(the current user) by any of my items
                                    if(snapshotChild.key == "toItem" && snapshotChild.value as! String == self.currentItemId) {
                                        print("found toItem")
                                        FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observe(.childAdded, with: { (snapshotAccepted) in
                                            // I cound't use req/accepted because we're pulling data, not setting values
                                            if(snapshotAccepted.key == "accepted" && snapshotAccepted.value as! String == "true") {
                                                print("found accepted")
                                                print(snapshotAccepted.value)
                                                self.contactBool = true
                                                self.navigationItem.rightBarButtonItem?.isEnabled = self.contactBool
                                                self.requestBool = false
                                                self.request.isEnabled = self.requestBool
                                                self.request.setTitle("Accepted", for: UIControlState())
                                                self.request.backgroundColor? = UIColor(red:0.15, green:0.83, blue:0.31, alpha:1.0)
                                            } else if(snapshotAccepted.key == "accepted"){
                                                print("found pending")
                                                self.requestBool = false
                                                self.request.isEnabled = self.requestBool
                                                self.request.setTitle("Pending", for: UIControlState())
                                                self.request.backgroundColor? = UIColor.gray
                                            }
                                            }, withCancel: nil)
                                    }
                                }, withCancel:nil)
                }, withCancel: nil)
                var one_iteration_only = 0
                FIRDatabase.database().reference().child("users").child(user.uid).child("requested").observe(.childAdded, with: { (snapshot) in
                    FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observe(.childAdded, with: { (snapshotChild) in
                        //created one_iteration_only to solve the problem of one item requesting many items from the same user, and the user should see accepted when he/she clicks on the item that the user requested from.
                        if(snapshotChild.key == "fromItem" && snapshotChild.value as! String == self.currentItemId) {
                            print("found from item before one_iteration")
                                print("found fromItem")
                                FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observe(.childAdded, with: { (snapshotAccepted) in
                                    // I cound't use req/accepted because we're pulling data, not setting values
                                    one_iteration_only = one_iteration_only + 1
                                    print(one_iteration_only)
                                    if (one_iteration_only == 1) {

                                        if(snapshotAccepted.key == "accepted" && snapshotAccepted.value as! String == "true") {
                                            print("found accepted")
                                            print(snapshotAccepted.value)
                                            self.contactBool = true
                                            self.navigationItem.rightBarButtonItem?.isEnabled = self.contactBool
                                            self.requestBool = false
                                            self.request.isEnabled = self.requestBool
                                            self.request.setTitle("Accepted ", for: UIControlState())
                                            self.request.backgroundColor? = UIColor(red:0.15, green:0.83, blue:0.31, alpha:1.0)
                                        } else if(snapshotAccepted.key == "accepted") {
                                            print("found pending")
                                            self.contactBool = false
                                            self.navigationItem.rightBarButtonItem?.isEnabled = self.contactBool
                                            self.requestBool = false
                                            self.request.isEnabled = self.requestBool
                                            self.request.setTitle("Pending ", for: UIControlState())
                                            self.request.backgroundColor? = UIColor.gray
                                            //just to give the accepted a priority
                                            one_iteration_only = 0
                                        } else {
                                            one_iteration_only = 0
                                        }
                                    }
                                }, withCancel: nil)
                            }
                        }, withCancel:nil)
                    }, withCancel: nil)
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var productDetails: UITextView = {
       let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(white:0.1, alpha:1.0)
        label.backgroundColor = UIColor(white:0.9, alpha:1.0)
        label.isEditable = false
        return label
    }()
    
    lazy var request: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(createRequest), for: .touchUpInside)
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
        dateLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
    }
    
    let lineseparator: UIView = {
        let horline = UIView()
        horline.backgroundColor = UIColor.black
        horline.translatesAutoresizingMaskIntoConstraints = false
        return horline
    }()
    
    func setupLineSep() {
        lineseparator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineseparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineseparator.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    let productTitle: UILabel = {
       let label = UILabel()
        label.font = UIFont(name:"Helvetica Neue", size: 18)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupProductTitle() {
        productTitle.topAnchor.constraint(equalTo: lineseparator.bottomAnchor, constant: 30).isActive = true
        productTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        productTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func createRequest() {
        if let user = FIRAuth.auth()?.currentUser {
            //signed in
            let requestController = RequestController()
            requestController.currentUser = user.uid
            requestController.toItemUserId = currentItem.userId
            requestController.toItemId = currentItemId
            let navcontroller = UINavigationController(rootViewController: requestController)
            self.present(navcontroller, animated: true, completion: nil)
            
        } else {
            print("user is not signed in/not authenticated")
            
        }
    }
    
    func contact() {
        let contactController = ContactController()
        contactController.userId = currentItem.userId
        let navController = UINavigationController(rootViewController: contactController)
        present(navController, animated: true, completion: nil)
    }

    
    func setupProductImage() {
        productImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        productImage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -7).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    func setupProductDetails() {
        productDetails.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 10).isActive = true
        productDetails.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        productDetails.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        productDetails.heightAnchor.constraint(equalToConstant: 70).isActive = true
        productDetails.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupRequestButton() {
        //need x, y, width, height constraints
        request.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        request.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -7).isActive = true
        request.widthAnchor.constraint(equalTo: productImage.widthAnchor).isActive = true
        request.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func home() {
        dismiss(animated: true, completion: nil)
    }
    
    func NumToDateToStr(_ date: NSNumber) -> String {
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.short
        
        dateformatter.timeStyle = DateFormatter.Style.short
        
        let NumToDate = Date(timeIntervalSinceReferenceDate: date as Double)
        
        let myddate = dateformatter.string(from: NumToDate)
        
        return myddate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
}
