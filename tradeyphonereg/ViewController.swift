//
//  ViewController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-07.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import DigitsKit
import Answers

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.v
        view.backgroundColor = UIColor(red:0.05, green:0.1, blue:0.15, alpha:1.0)
        self.view.addSubview(digitsButton)
        self.view.addSubview(logo)
        setupLoginButton()
        setupLogo()
    }
    
    let digitsButton = DGTAuthenticateButton(authenticationCompletion: { (session, error) in
        // Inspect session/error objects
        print(session.authToken)
        print(session.phoneNumber)
    })
    
    
    func didTapButton(sender: AnyObject) {
        print("tapping")
        let digits = Digits.sharedInstance()
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.phoneNumber = "+974"
        digits.authenticateWithViewController(nil, configuration: configuration) { session, error in
            // Country selector will be set to Spain
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
        logo.bottomAnchor.constraintEqualToAnchor(digitsButton.topAnchor, constant: -30).active = true
        logo.widthAnchor.constraintEqualToConstant(150).active = true
        logo.heightAnchor.constraintEqualToConstant(150).active = true
        
    }
    
    func setupLoginButton() {
        //need x,y and height constraints
        digitsButton.translatesAutoresizingMaskIntoConstraints = false
        digitsButton.setTitle("Login/Sign Up", forState: .Normal)
        digitsButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        digitsButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        digitsButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor,constant: -24).active = true
        digitsButton.heightAnchor.constraintEqualToConstant(60).active = true
        digitsButton.backgroundColor = UIColor(red:0.1, green:0.23, blue:0.37, alpha:1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }


}

