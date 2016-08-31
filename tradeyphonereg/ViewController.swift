//
//  ViewController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-07.
//  Copyright © 2016 abdul. All rights reserved.
//
// This page is for registering with phone number

import UIKit
import DigitsKit
import Answers
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        // Do any additional setup after loading the view, typically from a nib.v
        view.backgroundColor = UIColor(red:0.05, green:0.1, blue:0.15, alpha:1.0)
        navigationController!.navigationBarHidden = true

    }
    
    override func viewDidAppear(animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            print("user is fucking authenticated")
            print(user.email)
//            try! FIRAuth.auth()?.signOut()
            self.home()
            
        } else {
            // No user is signed in.
            self.view.addSubview(signUpWithNumber)
            self.view.addSubview(logo)
            setupLoginButton()
            setupLogo()
            signUpWithNumber.addTarget(self, action: #selector(didTapButton), forControlEvents: .TouchUpInside)
        }
    }
    
    
    let signUpWithNumber: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(red:0.1, green:0.23, blue:0.37, alpha:1.0)
        button.setTitle("Verify number", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.titleLabel?.textColor = UIColor.whiteColor()
        return button
        
    }()
    
    func emailLogin(number:String) {
        let loginController = LoginController()
        loginController.userPhoneNumber = number
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    func home() {
        let itemsViewController = ItemsViewController()
        let navigationController = UINavigationController(rootViewController: itemsViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func didTapButton(sender: AnyObject) {
        print("tapping")
        let digits = Digits.sharedInstance()
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.phoneNumber = "+974"
        digits.authenticateWithViewController(nil, configuration: configuration) { session, error in
            // Country selector will be set to Spain and phone number field will be set to 5555555555
            if(error != nil) {
                print("error")
                print(error)
            } else if(session != nil) {
                print(session.authToken)
                self.emailLogin(session.phoneNumber)
            }
        }
        
    }
    
    let logo:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tradey")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    func setupLogo() {
        //need x,y and height constraints
        logo.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        logo.bottomAnchor.constraintEqualToAnchor(signUpWithNumber.topAnchor, constant: -30).active = true
//        logo.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -70).active = true
        logo.widthAnchor.constraintEqualToConstant(150).active = true
        logo.heightAnchor.constraintEqualToConstant(150).active = true
        
    }
//
    func setupLoginButton() {
        //need x,y and height constraints
        signUpWithNumber.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        signUpWithNumber.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        signUpWithNumber.widthAnchor.constraintEqualToAnchor(view.widthAnchor,constant: -24).active = true
        signUpWithNumber.heightAnchor.constraintEqualToConstant(60).active = true
    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }


}

