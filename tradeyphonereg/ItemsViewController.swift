//
//  ItemsViewController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-09.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase
import UIKeyboardLikePickerTextField

class ItemsViewController: UITableViewController {
    
    var items = [Item]()
    var itemsFlexible = [Item]()
    var itemsIds = [String]()
    var itemsFlexibleIds = [String]()
    let cellId = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        print("We are Home baby")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: #selector(newItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "requests", style: .Plain, target: self, action: #selector(getRequests))
        navigationItem.title = "All"
        resetAllButtons()
        navigationController?.toolbarHidden = false
        let flexible = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let toolbarCarButton = UIBarButtonItem(customView: carButton)
        let toolbarComputerButton = UIBarButtonItem(customView: computerButton)
        let toolbarSofaButton = UIBarButtonItem(customView: sofaButton)
        let toolbarOtherButton = UIBarButtonItem(customView: otherButton)
        self.toolbarItems = [toolbarCarButton,flexible,toolbarComputerButton,flexible,toolbarSofaButton,flexible,toolbarOtherButton]
        
        // Do any additional setup after loading the view.
        tableView.registerClass(ItemCell.self, forCellReuseIdentifier: cellId)
        print("before fetching")
        fetchItems()
        
    }
    
    func getRequests() {
        let getRequestsController = GetRequestsController()
        let navController = UINavigationController(rootViewController: getRequestsController)
        presentViewController(navController, animated: true, completion: nil)
    }
    
    func fetchItems() {

        FIRDatabase.database().reference().child("items").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let item = Item()
                print(item)
                item.title = dictionary["title"] as! String
                item.desc = dictionary["description"] as! String
                item.itemImageUrl = dictionary["imageUrl"] as! String
                item.userId = dictionary["userId"] as! String
                item.timestamp = dictionary["timestamp"] as! NSNumber
                item.category = dictionary["category"] as! String
//                self.items.append(item)
//                self.itemsIds.append(snapshot.key)
                self.items.insert(item, atIndex: 0)
                self.itemsIds.insert(snapshot.key, atIndex: 0)
                self.itemsFlexible = self.items
                self.itemsFlexibleIds = self.itemsIds
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
                
            }
            }, withCancelBlock: nil)
        
    }
    
    lazy var carButton: UIButton = {
       let button = UIButton(frame: CGRectMake(0, 0, 40, 40))
        button.setImage(UIImage(named: "Car-40"), forState: .Normal)
        button.addTarget(self, action: #selector(carFunc), forControlEvents: .TouchUpInside)
        button.tintColor = UIColor.blackColor()
        return button
    }()
    
    func carFunc() {
        if(carButton.currentImage == UIImage(named: "Car-40")) {
        resetAllButtons()
        navigationItem.title = "Transportation"
            itemsFlexible.removeAll()
            itemsFlexibleIds.removeAll()
            //filter only the car categories items
            for (var i = 0;i < items.count; ++i) {
                if(items[i].category == "Transportation") {
                    itemsFlexible.append(items[i])
                    itemsFlexibleIds.append(itemsIds[i])
                }
            }
            print("carButton pressed")
            carButton.setImage(UIImage(named: "Car Filled-40"), forState: .Normal)
            self.tableView.reloadData()
        }
        else {
            //do nothing, as the button is already pressed
        }
    }
    
    lazy var computerButton: UIButton = {
        let button = UIButton(frame: CGRectMake(0, 0, 40, 40))
        button.setImage(UIImage(named: "iMac-40"), forState: .Normal)
        button.addTarget(self, action: #selector(computerFunc), forControlEvents: .TouchUpInside)
        button.tintColor = UIColor.blackColor()
        return button
    }()
    
    func computerFunc() {
        if(computerButton.currentImage == UIImage(named: "iMac-40")) {
            navigationItem.title = "Electronics"
            resetAllButtons()
            itemsFlexible.removeAll()
            itemsFlexibleIds.removeAll()
            for (var i = 0;i < items.count; ++i) {
                if(items[i].category == "Electronics") {
                    itemsFlexible.append(items[i])
                    itemsFlexibleIds.append(itemsIds[i])
                }
            }
            print("computerButton pressed")
            computerButton.setImage(UIImage(named: "iMac Filled-40"), forState: .Normal)
            self.tableView.reloadData()
        }
        else {
            //do nothing, as the button is already pressed
        }
    }
    
    lazy var sofaButton: UIButton = {
        let button = UIButton(frame: CGRectMake(0, 0, 40, 40))
        button.setImage(UIImage(named: "Sofa-40"), forState: .Normal)
        button.addTarget(self, action: #selector(sofaFunc), forControlEvents: .TouchUpInside)
        button.tintColor = UIColor.blackColor()
        return button
    }()
    
    func sofaFunc() {
        if(sofaButton.currentImage == UIImage(named: "Sofa-40")) {
            navigationItem.title = "Furniture"
            resetAllButtons()
            itemsFlexible.removeAll()
            itemsFlexibleIds.removeAll()
            for (var i = 0;i < items.count; ++i) {
                if(items[i].category == "Furniture") {
                    itemsFlexible.append(items[i])
                    itemsFlexibleIds.append(itemsIds[i])
                }
            }
            print("sofaButton pressed")
            sofaButton.setImage(UIImage(named: "Sofa Filled-40"), forState: .Normal)
            self.tableView.reloadData()
        }
        else {
            //do nothing, as the button is already pressed
        }
    }
    
    lazy var otherButton: UIButton = {
        let button = UIButton(frame: CGRectMake(0, 0, 40, 40))
        button.setImage(UIImage(named: "More-40"), forState: .Normal)
        button.addTarget(self, action: #selector(otherFunc), forControlEvents: .TouchUpInside)
        button.tintColor = UIColor.blackColor()
        return button
    }()
    
    func otherFunc() {
        if(otherButton.currentImage == UIImage(named: "More-40")) {
            navigationItem.title = "Other"
            resetAllButtons()
            itemsFlexible.removeAll()
            itemsFlexibleIds.removeAll()
            for (var i = 0;i < items.count; ++i) {
                if(items[i].category == "Other") {
                    itemsFlexible.append(items[i])
                    itemsFlexibleIds.append(itemsIds[i])
                }
            }
            print("otherButton pressed")
            otherButton.setImage(UIImage(named: "More Filled-40"), forState: .Normal)
            self.tableView.reloadData()
        }
        else {
            //do nothing, as the button is already pressed
        }
    }
    
    
    
    func resetAllButtons() {
        //resets all buttons to default looks, so that when i press one button the already pressed one resets to default
        carButton.setImage(UIImage(named: "Car-40"), forState: .Normal)
        computerButton.setImage(UIImage(named: "iMac-40"), forState: .Normal)
        sofaButton.setImage(UIImage(named: "Sofa-40"), forState: .Normal)
        otherButton.setImage(UIImage(named: "More-40"), forState: .Normal)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        let showViewController = ShowViewController()
        showViewController.currentItem = itemsFlexible[indexPath.row]
        showViewController.currentItemId = itemsFlexibleIds[indexPath.row]
        let navigationController = UINavigationController(rootViewController: showViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsFlexible.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cell view")
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ItemCell
        let item = itemsFlexible[indexPath.row]
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
    
    func newItem() {
        let addViewController = AddViewController()
        let navigationController = UINavigationController(rootViewController: addViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    

}

class ItemCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(86, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRectMake(86 , detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageView)
        
        itemImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        itemImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        itemImageView.widthAnchor.constraintEqualToConstant(70).active = true
        itemImageView.heightAnchor.constraintEqualToConstant(70).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
