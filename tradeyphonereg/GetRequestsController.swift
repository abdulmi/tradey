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
    
    /////////////////////////Requests that were sent the current user(me)////////////////////////////////

    //total numbers of accpeted/pending requests will all of their items attributes
    var myRequested = [String]()
    var toItems = [Item]()
    var fromItems = [Item]()
    var fromItemsIds = [String]()
    var toItemsIds = [String]()
    var requestAcceptDecline = [String]()
    
    //requests attributes only for accepted(true) requests
    var fromItemsAccepted = [Item]()
    var toItemsAccepted = [Item]()
    var fromItemsIdsAccepted = [String]()
    var toItemsIdsAccepted = [String]()
    var myRequestedAccepted = [String]()
    
    //requests attributes only for pending(false) requests
    var fromItemsPending = [Item]()
    var toItemsPending = [Item]()
    var fromItemsIdsPending = [String]()
    var toItemsIdsPending = [String]()
    var myRequestedPending = [String]()
    
    //requests attributes that are used on the page, so that we can change them anytime
    var fromItemsFlexible = [Item]()
    var toItemsFlexible = [Item]()
    var fromItemsIdsFlexible = [String]()
    var toItemsIdsFlexible = [String]()
    var myRequestedFlexible = [String]()
    
    /////////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////requests that the user sent//////////////////////////////
    
    //total numbers of accepeted/pending requests with all of their items attributes
    var myRequests = [String]()
    var myRequestsAccDec = [String]()
    var fromItemsReqs = [Item]()
    var fromItemsIdsReqs = [String]()
    var toItemsReqs = [Item]()
    var toItemsIdsReqs = [String]()
    
    /////////////////////////////////////////////////////////////////////////////////////////
    
    let cellIdReq = "RequestCell"
    let cellIdReqAcc = "NormalCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
        let toolbarTitle = UIBarButtonItem(customView: headTitle)
        let toolbarSeparator = UIBarButtonItem(customView: blackline)
        let toolbarTitleRight = UIBarButtonItem(customView: headTitleRight)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbarItems = [toolbarTitle,flexible,toolbarSeparator,flexible,toolbarTitleRight]
        self.navigationItem.titleView = toggleRequests
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(home))
        tableView.register(RequestCell.self, forCellReuseIdentifier: cellIdReq)
        tableView.register(RequestCellAccepted.self, forCellReuseIdentifier: cellIdReqAcc)
        if let user = FIRAuth.auth()?.currentUser {
            //signed in
            //getting all the requests from people to me to show in the requests page
            FIRDatabase.database().reference().child("users").child(user.uid).child("requested").observe(.childAdded, with: { (snapshot) in
                    self.myRequested.append(snapshot.value as! String)
                FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observe(.childAdded, with: { (snapshotChild) in
                    print("here bitch")
                    
                        if(snapshotChild.key == "fromItem") {
                            self.fromItemsIds.append(snapshotChild.value as! String)
                            let item = Item()
                            FIRDatabase.database().reference().child("items").child(snapshotChild.value as! String).observe(.childAdded, with: { (snapshotChildItem) in
                                print("inside item requested")
                                //hacky way of setting the keys in item, becuase snapshot gives one key at a time inside the item's     key
                                if(snapshotChildItem.key == "title") {
//                                  print(snapshotChildItem.value as! String)
                                    item.title = snapshotChildItem.value as! String
                                } else if(snapshotChildItem.key == "description") {
//                                  print(snapshotChildItem.value as! String)
                                    item.desc = snapshotChildItem.value as! String
                                } else if(snapshotChildItem.key == "imageUrl") {
//                                  print(snapshotChildItem.value as! String)
                                    item.itemImageUrl = snapshotChildItem.value as! String
                                } else if(snapshotChildItem.key == "userId") {
//                                  print(snapshotChildItem.value as! String)
                                    item.userId = snapshotChildItem.value as! String
                                } else if(snapshotChildItem.key == "timestamp") {
                                    item.timestamp = snapshotChildItem.value as! NSNumber
                                } else if(snapshotChildItem.key == "category") {
                                    item.category = snapshotChildItem.value as! String
                                }
                                    DispatchQueue.main.async(execute: {
                                        self.tableView.reloadData()
                                    })
                                }, withCancel: nil)
                            self.fromItems.append(item)
                        } else if(snapshotChild.key == "toItem") {
                            self.toItemsIds.append(snapshotChild.value as! String)
                            let item = Item()
                            FIRDatabase.database().reference().child("items").child(snapshotChild.value as! String).observe(.childAdded, with: { (snapshotChildItem) in
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
                                } else if(snapshotChildItem.key == "timestamp") {
                                    item.timestamp = snapshotChildItem.value as! NSNumber
                                } else if(snapshotChildItem.key == "category") {
                                    item.category = snapshotChildItem.value as! String
                                }
                                DispatchQueue.main.async(execute: {
                                    self.tableView.reloadData()
                                })
                                }, withCancel: nil)
                            self.toItems.append(item)
                        } else if(snapshotChild.key == "accepted") {
                                self.requestAcceptDecline.append(snapshotChild.value as! String)
                        }
                    
                    
                        }, withCancel: nil)
                    }, withCancel: nil)
            
            
            //getting all the requests that you(the current user) sent out
            FIRDatabase.database().reference().child("users").child(user.uid).child("requests").observe(.childAdded, with: { (snapshot) in
                    self.myRequests.append(snapshot.value as! String)
                FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observe(.childAdded, with: { (snapshotChild) in
                    if(snapshotChild.key == "accepted" && snapshotChild.value as! String == "true"){
                        FIRDatabase.database().reference().child("requests").child(snapshot.value as! String).observe(.childAdded, with: { (snapshotAccepted) in
                            if(snapshotAccepted.key == "fromItem") {
                                self.fromItemsIdsReqs.append(snapshotAccepted.value as! String)
                                let item = Item()
                                FIRDatabase.database().reference().child("items").child(snapshotAccepted.value as! String).observe(.childAdded, with: { (snapshotItem) in
                                    if(snapshotItem.key == "description"){
                                        item.desc = snapshotItem.value as! String
                                    } else if(snapshotItem.key == "imageUrl") {
                                        item.itemImageUrl = snapshotItem.value as! String
                                    } else if(snapshotItem.key == "title") {
                                        item.title = snapshotItem.value as! String
                                    } else if(snapshotItem.key == "userId") {
                                        item.userId = snapshotItem.value as! String
                                    } else if(snapshotItem.key == "timestamp") {
                                        item.timestamp = snapshotItem.value as! NSNumber
                                    } else if(snapshotItem.key == "category") {
                                        item.category = snapshotItem.value as! String
                                    }
                                    DispatchQueue.main.async(execute: {
                                        self.tableView.reloadData()
                                    })
                                    }, withCancel: nil)
                                self.fromItemsReqs.append(item)
                            } else if(snapshotAccepted.key == "toItem") {
                                self.toItemsIdsReqs.append(snapshotAccepted.value as! String)
                                let item = Item()
                                FIRDatabase.database().reference().child("items").child(snapshotAccepted.value as! String).observe(.childAdded, with: { (snapshotItem) in
                                    if(snapshotItem.key == "description"){
                                        item.desc = snapshotItem.value as! String
                                    } else if(snapshotItem.key == "imageUrl") {
                                        item.itemImageUrl = snapshotItem.value as! String
                                    } else if(snapshotItem.key == "title") {
                                        item.title = snapshotItem.value as! String
                                    } else if(snapshotItem.key == "userId") {
                                        item.userId = snapshotItem.value as! String
                                    } else if(snapshotItem.key == "timestamp") {
                                        item.timestamp = snapshotItem.value as! NSNumber
                                    } else if(snapshotItem.key == "category") {
                                        item.category = snapshotItem.value as! String
                                    }
                                    DispatchQueue.main.async(execute: {
                                        self.tableView.reloadData()
                                    })
                                    }, withCancel: nil)
                                self.toItemsReqs.append(item)
                            }
                            DispatchQueue.main.async(execute: {
                                self.tableView.reloadData()
                            })
                            }, withCancel: nil)
                    }
                    }, withCancel: nil)
                }, withCancel: nil)
        } else {
            //not authenticated
        }
        
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.toolbarHidden = true
//    }
    
    
    lazy var toggleRequests: UISegmentedControl = {
        let menu = ["Pending", "Accepted"]
        let segmentControl = UISegmentedControl(items: menu)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(changeRequests), for: .valueChanged)
        segmentControl.layer.masksToBounds = true
        return segmentControl
    }()
    

    func changeRequests(_ sender: UISegmentedControl) {
        for i in 0 ... requestAcceptDecline.count-1 {
            if(requestAcceptDecline[i] == "true") {
                fromItemsIdsAccepted.append(fromItemsIds[i])
                fromItemsAccepted.append(fromItems[i])
                toItemsAccepted.append(toItems[i])
                toItemsIdsAccepted.append(toItemsIds[i])
                myRequestedAccepted.append(myRequested[i])
            } else {
                fromItemsIdsPending.append(fromItemsIds[i])
                fromItemsPending.append(fromItems[i])
                toItemsPending.append(toItems[i])
                toItemsIdsPending.append(toItemsIds[i])
                myRequestedPending.append(myRequested[i])
            }
        }
        switch sender.selectedSegmentIndex {
        case 1:
            print("Accepted")
            fromItemsFlexible = fromItemsAccepted + fromItemsReqs
            fromItemsIdsFlexible = fromItemsIdsAccepted + fromItemsIdsReqs
            toItemsFlexible = toItemsAccepted + toItemsReqs
            toItemsIdsFlexible = toItemsIdsAccepted + toItemsIdsReqs
            myRequestedFlexible = myRequestedAccepted
            
            fromItemsIdsAccepted.removeAll()
            fromItemsIdsPending.removeAll()
            fromItemsAccepted.removeAll()
            fromItemsPending.removeAll()
            toItemsIdsAccepted.removeAll()
            toItemsIdsPending.removeAll()
            toItemsAccepted.removeAll()
            toItemsPending.removeAll()
            myRequestedAccepted.removeAll()
            myRequestedPending.removeAll()
            self.tableView.reloadData()
        default:
            print("Pending")
            fromItemsFlexible = fromItemsPending
            fromItemsIdsFlexible = fromItemsIdsPending
            toItemsFlexible = toItemsPending
            toItemsIdsFlexible = toItemsIdsPending
            myRequestedFlexible = myRequestedPending
            
            fromItemsIdsAccepted.removeAll()
            fromItemsIdsPending.removeAll()
            fromItemsAccepted.removeAll()
            fromItemsPending.removeAll()
            toItemsIdsAccepted.removeAll()
            toItemsIdsPending.removeAll()
            toItemsAccepted.removeAll()
            toItemsPending.removeAll()
            myRequestedAccepted.removeAll()
            myRequestedPending.removeAll()
            self.tableView.reloadData()
        }
    }
    
    lazy var headTitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.text = "Theirs"
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    lazy var headTitleRight: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.text = "Yours"
        label.textColor = UIColor.black
        label.textAlignment = .right
        return label
    }()
    
    
    func home() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showViewController = ShowViewController()
        if (fromItemsIdsReqs.contains(fromItemsIdsFlexible[indexPath.row])) {
            showViewController.currentItemId = toItemsIdsFlexible[indexPath.row]
            showViewController.currentItem = toItemsFlexible[indexPath.row]
        } else {
            showViewController.currentItemId = fromItemsIdsFlexible[indexPath.row]
            showViewController.currentItem = fromItemsFlexible[indexPath.row]
        }
        let navController = UINavigationController(rootViewController: showViewController)
        present(navController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("hey dick")
        print(fromItemsFlexible)
        print(toItemsFlexible)
        print(myRequests)
        print(fromItemsIdsReqs)
        print(toItemsIdsReqs)
        print(fromItemsReqs)
        print(toItemsReqs
        )
        return fromItemsFlexible.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //pending(can accept or decline)
        if (toggleRequests.selectedSegmentIndex == 0) {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdReq, for: indexPath) as! RequestCell
        print("hey dick2")
        cell.textLabel?.text = fromItemsFlexible[indexPath.row].title
//        cell.detailTextLabel?.text = fromItemsFlexible[indexPath.row].desc
        cell.ItemRightText.text = toItemsFlexible[indexPath.row].title
//        cell.ItemRightDetail.text = toItemsFlexible[indexPath.row].desc
        if let imageUrlLeft = fromItemsFlexible[indexPath.row].itemImageUrl {
            cell.itemImageViewLeft.loadImageUsingCacheWithUrlString(imageUrlLeft)
        }
        if let imageUrlRight = toItemsFlexible[indexPath.row].itemImageUrl {
            cell.itemImageViewRight.loadImageUsingCacheWithUrlString(imageUrlRight)
        }
        
        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(accept), for: .touchUpInside)
        cell.declineButton.addTarget(self, action: #selector(decline), for: .touchUpInside)
        // Configure the cell...
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdReqAcc, for: indexPath) as! RequestCellAccepted
            print("hey dick2")
            //setting the theirs/yours classification
            if let user = FIRAuth.auth()?.currentUser {
                if user.uid == toItemsFlexible[indexPath.row].userId {
                    cell.ItemRightText.text = toItemsFlexible[indexPath.row].title
//                    cell.ItemRightDetail.text = toItemsFlexible[indexPath.row].desc
                    if let imageUrlRight = toItemsFlexible[indexPath.row].itemImageUrl {
                        cell.itemImageViewRight.loadImageUsingCacheWithUrlString(imageUrlRight)
                    }
                    cell.textLabel?.text = fromItemsFlexible[indexPath.row].title
//                    cell.detailTextLabel?.text = fromItemsFlexible[indexPath.row].desc
                    if let imageUrlLeft = fromItemsFlexible[indexPath.row].itemImageUrl {
                    cell.itemImageViewLeft.loadImageUsingCacheWithUrlString(imageUrlLeft)
                    
                    }
                    
                } else {
                    cell.ItemRightText.text = fromItemsFlexible[indexPath.row].title
//                    cell.ItemRightDetail.text = fromItemsFlexible[indexPath.row].desc
                    if let imageUrlRight = fromItemsFlexible[indexPath.row].itemImageUrl {
                        cell.itemImageViewRight.loadImageUsingCacheWithUrlString(imageUrlRight)
                    }
                    cell.textLabel?.text = toItemsFlexible[indexPath.row].title
//                    cell.detailTextLabel?.text = toItemsFlexible[indexPath.row].desc
                    if let imageUrlLeft = toItemsFlexible[indexPath.row].itemImageUrl {
                        cell.itemImageViewLeft.loadImageUsingCacheWithUrlString(imageUrlLeft)
                        
                    }
                }
            }
// old way of ordering items
            
//            cell.textLabel?.text = fromItemsFlexible[indexPath.row].title
//            cell.detailTextLabel?.text = fromItemsFlexible[indexPath.row].desc
//            cell.ItemRightText.text = toItemsFlexible[indexPath.row].title
//            cell.ItemRightDetail.text = toItemsFlexible[indexPath.row].desc
//            if let imageUrlLeft = fromItemsFlexible[indexPath.row].itemImageUrl {
//                cell.itemImageViewLeft.loadImageUsingCacheWithUrlString(imageUrlLeft)
//            }
//            if let imageUrlRight = toItemsFlexible[indexPath.row].itemImageUrl {
//                cell.itemImageViewRight.loadImageUsingCacheWithUrlString(imageUrlRight)
//            }
            return cell
        }
    }
    
    lazy var blackline: UIView = {
        let blackView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 30))
        blackView.backgroundColor = UIColor.black
        return blackView
    }()
    
    
    func accept(_ sender:UIButton) {
        let buttonRow = sender.tag
        print(buttonRow)
        print(myRequested)
        let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to accept the request?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let ref = FIRDatabase.database().reference(fromURL: "https://tradey2-0.firebaseio.com/")
            let requestAccepted = FIRDatabase.database().reference().child("requests").child(self.myRequestedFlexible[buttonRow]+"/accepted")
            requestAccepted.setValue("true")
            print("TRUE")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("NO")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
 
    func decline(_ sender:UIButton) {
        let buttonRow = sender.tag
        //nothing todo since the request is already false, in the future will delete request
        let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to decline the request?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            var requestKey:String!
            FIRDatabase.database().reference().child("requests").observe(.childAdded, with: { (snapshot) in
                if (self.myRequestedFlexible[buttonRow] == snapshot.key) {
                if let dic = snapshot.value as? [String:AnyObject] {
                    requestKey = snapshot.key
                    let request = Request()
                    print(request)
                    request.fromItem = dic["fromItem"] as! String
                    request.fromUser = dic["fromUser"] as! String
                    request.toItem = dic["toItem"] as! String
                    request.toUser = dic["toUser"] as! String
                    request.accepted = dic["accepted"] as! String
                    let ref = FIRDatabase.database().reference(fromURL: "https://tradey2-0.firebaseio.com/")
                    let requestAccepted = FIRDatabase.database().reference().child("requests").child(requestKey)
                    requestAccepted.removeValue()
                    let fromUserRequest = FIRDatabase.database().reference().child("users").child(request.fromUser!).child("requests").child(requestKey)
                    fromUserRequest.removeValue()
                    let toUserRequest = FIRDatabase.database().reference().child("users").child(request.toUser!).child("requested").child(requestKey)
                    toUserRequest.removeValue()
                }
                    
                }

                }, withCancel: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("NO")
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        print("FALSE")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //disable orientaion
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

}

class RequestCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 86, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
//        detailTextLabel?.frame = CGRectMake(86 , detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    
    let ItemRightText: UILabel = {
        let label = UILabel(frame: CGRect(x: 235, y: 31.5, width: 70, height: 15))
        label.adjustsFontSizeToFitWidth = true
        //        label.contentMode = .ScaleAspectFit
        return label
    }()
//
//    let ItemRightDetail: UILabel = {
//        let detail = UILabel(frame: CGRectMake(235, 55, 70, 15))
//        detail.font = detail.font.fontWithSize(12)
//        detail.adjustsFontSizeToFitWidth = true
//        return detail
//    }()
    
    let itemImageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let itemImageViewRight: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Checkmark-30")
        button.setImage(image, for: UIControlState())
//        button.addTarget(self, action: #selector(accept), forControlEvents: .TouchUpInside)
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Cancel-30")
        button.setImage(image, for: UIControlState())
//        button.addTarget(self, action: #selector(decline), forControlEvents: .TouchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageViewLeft)
        addSubview(itemImageViewRight)
        addSubview(acceptButton)
        addSubview(declineButton)
        addSubview(ItemRightText)
//        addSubview(ItemRightDetail)
        
        itemImageViewLeft.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        itemImageViewLeft.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageViewLeft.widthAnchor.constraint(equalToConstant: 70).isActive = true
        itemImageViewLeft.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        itemImageViewRight.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        itemImageViewRight.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageViewRight.widthAnchor.constraint(equalToConstant: 70).isActive = true
        itemImageViewRight.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        acceptButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        acceptButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -20).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        declineButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        declineButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 20).isActive = true
        declineButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RequestCellAccepted: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 86, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
//
//        detailTextLabel?.frame = CGRectMake(86 , detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    
    let ItemRightText: UILabel = {
        let label = UILabel(frame: CGRect(x: 250, y: 40, width: 70, height: 15))
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
//
//    let ItemRightDetail: UILabel = {
//       let detail = UILabel(frame: CGRectMake(235, 55, 70, 15))
//        detail.font = detail.font.fontWithSize(12)
//        detail.adjustsFontSizeToFitWidth = true
//        return detail
//    }()
    
    let itemImageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let itemImageViewRight: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageViewLeft)
        addSubview(itemImageViewRight)
        addSubview(ItemRightText)
//        addSubview(ItemRightDetail)
        
        itemImageViewLeft.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        itemImageViewLeft.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageViewLeft.widthAnchor.constraint(equalToConstant: 70).isActive = true
        itemImageViewLeft.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        itemImageViewRight.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        itemImageViewRight.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageViewRight.widthAnchor.constraint(equalToConstant: 70).isActive = true
        itemImageViewRight.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




