//
//  ItemsViewController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-09.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase

class ItemsViewController: UITableViewController {
    
    var items = [Item]()
    var itemsIds = [String]()
    let cellId = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("We are Home baby")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: #selector(newItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "requests", style: .Plain, target: self, action: #selector(getRequests))
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
                self.items.append(item)
                self.itemsIds.append(snapshot.key)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
                
            }
            
            }, withCancelBlock: nil)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        let showViewController = ShowViewController()
        showViewController.currentItem = items[indexPath.row]
        showViewController.currentItemId = itemsIds[indexPath.row]
        let navigationController = UINavigationController(rootViewController: showViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
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
