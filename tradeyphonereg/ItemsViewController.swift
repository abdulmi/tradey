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
    var itemsFlexible = [Item]()
    var itemsIds = [String]()
    var itemsFlexibleIds = [String]()
    let cellId = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        print("We are Home baby")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(newItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "requests", style: .plain, target: self, action: #selector(getRequests))
        navigationItem.title = "All"
        resetAllButtons()
        navigationController?.isToolbarHidden = false
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolbarCarButton = UIBarButtonItem(customView: carButton)
        let toolbarComputerButton = UIBarButtonItem(customView: computerButton)
        let toolbarSofaButton = UIBarButtonItem(customView: sofaButton)
        let toolbarOtherButton = UIBarButtonItem(customView: otherButton)
        self.toolbarItems = [toolbarCarButton,flexible,toolbarComputerButton,flexible,toolbarSofaButton,flexible,toolbarOtherButton]
        
        // Do any additional setup after loading the view.
        tableView.register(ItemCell.self, forCellReuseIdentifier: cellId)
        print("before fetching")
        fetchItems()
        
    }
    
    func getRequests() {
        let getRequestsController = GetRequestsController()
        let navController = UINavigationController(rootViewController: getRequestsController)
        present(navController, animated: true, completion: nil)
    }
    
    func fetchItems() {

        FIRDatabase.database().reference().child("items").observe(.childAdded, with: { (snapshot) in
            
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
                self.items.insert(item, at: 0)
                self.itemsIds.insert(snapshot.key, at: 0)
                self.itemsFlexible = self.items
                self.itemsFlexibleIds = self.itemsIds
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
            }
            }, withCancel: nil)
        
    }
    
    lazy var carButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(named: "Car-40"), for: UIControlState())
        button.addTarget(self, action: #selector(carFunc), for: .touchUpInside)
        button.tintColor = UIColor.black
        return button
    }()
    
    func carFunc() {
        if(carButton.currentImage == UIImage(named: "Car-40")) {
        resetAllButtons()
        navigationItem.title = "Transportation"
            itemsFlexible.removeAll()
            itemsFlexibleIds.removeAll()
            //filter only the car categories items
            for i in 0 ... items.count-1 {
                if(items[i].category == "Transportation") {
                    itemsFlexible.append(items[i])
                    itemsFlexibleIds.append(itemsIds[i])
                }
            }
            print("carButton pressed")
            carButton.setImage(UIImage(named: "Car Filled-40"), for: UIControlState())
            self.tableView.reloadData()
        }
        else {
            //do nothing, as the button is already pressed
        }
    }
    
    lazy var computerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(named: "iMac-40"), for: UIControlState())
        button.addTarget(self, action: #selector(computerFunc), for: .touchUpInside)
        button.tintColor = UIColor.black
        return button
    }()
    
    func computerFunc() {
        if(computerButton.currentImage == UIImage(named: "iMac-40")) {
            navigationItem.title = "Electronics"
            resetAllButtons()
            itemsFlexible.removeAll()
            itemsFlexibleIds.removeAll()
            for i in 0 ... items.count-1 {
                if(items[i].category == "Electronics") {
                    itemsFlexible.append(items[i])
                    itemsFlexibleIds.append(itemsIds[i])
                }
            }
            print("computerButton pressed")
            computerButton.setImage(UIImage(named: "iMac Filled-40"), for: UIControlState())
            self.tableView.reloadData()
        }
        else {
            //do nothing, as the button is already pressed
        }
    }
    
    lazy var sofaButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(named: "Sofa-40"), for: UIControlState())
        button.addTarget(self, action: #selector(sofaFunc), for: .touchUpInside)
        button.tintColor = UIColor.black
        return button
    }()
    
    func sofaFunc() {
        if(sofaButton.currentImage == UIImage(named: "Sofa-40")) {
            navigationItem.title = "Furniture"
            resetAllButtons()
            itemsFlexible.removeAll()
            itemsFlexibleIds.removeAll()
            for i in 0 ... items.count-1 {
                if(items[i].category == "Furniture") {
                    itemsFlexible.append(items[i])
                    itemsFlexibleIds.append(itemsIds[i])
                }
            }
            print("sofaButton pressed")
            sofaButton.setImage(UIImage(named: "Sofa Filled-40"), for: UIControlState())
            self.tableView.reloadData()
        }
        else {
            //do nothing, as the button is already pressed
        }
    }
    
    lazy var otherButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(named: "More-40"), for: UIControlState())
        button.addTarget(self, action: #selector(otherFunc), for: .touchUpInside)
        button.tintColor = UIColor.black
        return button
    }()
    
    func otherFunc() {
        if(otherButton.currentImage == UIImage(named: "More-40")) {
            navigationItem.title = "Other"
            resetAllButtons()
            itemsFlexible.removeAll()
            itemsFlexibleIds.removeAll()
            for i in 0 ... items.count-1 {
                if(items[i].category == "Other") {
                    itemsFlexible.append(items[i])
                    itemsFlexibleIds.append(itemsIds[i])
                }
            }
            print("otherButton pressed")
            otherButton.setImage(UIImage(named: "More Filled-40"), for: UIControlState())
            self.tableView.reloadData()
        }
        else {
            //do nothing, as the button is already pressed
        }
    }
    
    
    
    func resetAllButtons() {
        //resets all buttons to default looks, so that when i press one button the already pressed one resets to default
        carButton.setImage(UIImage(named: "Car-40"), for: UIControlState())
        computerButton.setImage(UIImage(named: "iMac-40"), for: UIControlState())
        sofaButton.setImage(UIImage(named: "Sofa-40"), for: UIControlState())
        otherButton.setImage(UIImage(named: "More-40"), for: UIControlState())
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let showViewController = ShowViewController()
        showViewController.currentItem = itemsFlexible[indexPath.row]
        showViewController.currentItemId = itemsFlexibleIds[indexPath.row]
        let navigationController = UINavigationController(rootViewController: showViewController)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsFlexible.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell view")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemCell
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
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    

}

class ItemCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 86, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 86 , y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(itemImageView)
        
        itemImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
