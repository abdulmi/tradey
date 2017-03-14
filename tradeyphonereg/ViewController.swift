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
import JWT
import KeychainSwift

//struct defaultsKeys {
//    static let keyOne = "AccessKey"
//}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        // Do any additional setup after loading the view, typically from a nib.v
        view.backgroundColor = UIColor(red:0.05, green:0.1, blue:0.15, alpha:1.0)
        navigationController!.isNavigationBarHidden = true
        let keychain = KeychainSwift()
        // do not uncomment this LOOL
//        keychain.delete("accessKey")
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let user = FIRAuth.auth()?.currentUser {
//            // User is signed in.
//            print("user is fucking authenticated")
//            print(user.email)
////            try! FIRAuth.auth()?.signOut()
//            self.home()
//            
//        } else {
            // No user is signed in.
//            let defaults = UserDefaults.standard
            let keychain = KeychainSwift()
            //trying to get key
            if let accessKey = keychain.get("accessKey") {
                print("already have access key stored")
                do {
                    let claims = try JWT.decode(accessKey, algorithm: .hs256("secret".data(using: .utf8)!))
                    print(claims)
                    self.home()
                } catch {
                    print("Failed to decode JWT: \(error)")
                }
            } else {
                print("first time opening app")
                //generating/setting key
                self.view.addSubview(signUpWithNumber)
                setupLoginButton()
                self.view.addSubview(logo)
                setupLogo()
//                setupLoginButton()
                signUpWithNumber.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            }
//        }
    }

    
    let signUpWithNumber: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.1, green:0.23, blue:0.37, alpha:1.0)
        button.setTitle("Verify number", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.textColor = UIColor.white
        return button
        
    }()
    
    func emailLogin(_ number:String) {
        let loginController = LoginController()
        loginController.userPhoneNumber = number
        present(loginController, animated: true, completion: nil)
    }
    
    func home() {
        let itemsViewController = ItemsViewController()
        let navigationController = UINavigationController(rootViewController: itemsViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func didTapButton(_ sender: AnyObject) {
        print("tapping")
        let digits = Digits.sharedInstance()
        let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
        configuration?.phoneNumber = "+974"
        digits.authenticate(with: nil, configuration: configuration!) { session, error in
            // Country selector will be set to Spain and phone number field will be set to 5555555555
            if(error != nil) {
                print("error")
                print(error)
            } else if(session != nil) {
                print("authenticating right now...")
                print(session?.authToken)
//                self.emailLogin(session.phoneNumber)
//                let defaults = UserDefaults.standard
                print("NUM")
                print(session?.phoneNumber)
                let k = JWT.encode(["phone": session?.phoneNumber], algorithm: .hs256("secret".data(using: .utf8)!))
//                defaults.setValue(k, forKey: defaultsKeys.keyOne)
//                defaults.synchronize()
                let keychain = KeychainSwift()
                keychain.set(k, forKey: "accessKey")
                self.home()
            }
        }
        
    }
//
//    func didTapButton(_ sender: AnyObject) {
//        let authButton = DGTAuthenticateButton(authenticationCompletion: { session, error in
//            if (session != nil) {
//                // TODO: associate the session userID with your user model
//                let message = "Phone number: \(session!.phoneNumber)"
//                let alertController = UIAlertController(title: "You are logged in!", message: message, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: .none))
//                print("LOOL")
//                self.present(alertController, animated: true, completion: .none)
//                let k = JWT.encode(["phone": session?.phoneNumber], algorithm: .hs256("secret".data(using: .utf8)!))
//                let keychain = KeychainSwift()
//                keychain.set(k, forKey: "accessKey")
//                print(k)
//                self.home()
//            } else {
//                NSLog("Authentication error: %@", error!.localizedDescription)
//            }
//        })
//        authButton?.center = self.view.center
//        self.view.addSubview(authButton!)
//    }
//    
    let logo:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tradey")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func setupLogo() {
        //need x,y and height constraints
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.bottomAnchor.constraint(equalTo: signUpWithNumber.topAnchor, constant: -30).isActive = true
//        logo.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -70).active = true
        logo.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
//
    func setupLoginButton() {
        //need x,y and height constraints
        signUpWithNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpWithNumber.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signUpWithNumber.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -24).isActive = true
        signUpWithNumber.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }


}

