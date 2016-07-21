//
//  AddViewController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-09.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var itemImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.05, green:0.1, blue:0.15, alpha:1.0)
        
        descriptionTextField.text = "Describe your item"
        descriptionTextField.textColor = UIColor.lightGrayColor()
        
        view.addSubview(inputsContainerView)
        view.addSubview(takePhoto)
        view.addSubview(addViewTitle)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupAddViewTitle()
        print("AddnewItem")
        // Do any additional setup after loading the view
        self.navigationController!.navigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(home))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: #selector(submitItem))

    }
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let addViewTitle: UILabel = {
        let label = UILabel()
        label.text = "Create Item"
        label.textColor = UIColor.whiteColor()
        label.font = label.font.fontWithSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        return label
    }()
    
    lazy var takePhoto: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Take Photo", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(openCam), forControlEvents: .TouchUpInside)
        return button
    }()
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let titleSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var descriptionTextField: UITextView = {
        let tf = UITextView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        return tf
    }()
    
    func textViewDidBeginEditing(textView: UITextView) {
        print("did begin editing")
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func openCam() {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your item"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    let descriptionSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func home() {
            dismissViewControllerAnimated(true, completion: nil)
    }

    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        inputsContainerView.heightAnchor.constraintEqualToConstant(100).active = true
        
        inputsContainerView.addSubview(titleTextField)
        inputsContainerView.addSubview(titleSeparatorView)
        inputsContainerView.addSubview(descriptionTextField)
//        inputsContainerView.addSubview(descriptionSeparatorView)
        
        //need x, y, width, height constraints
        titleTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        titleTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        
        titleTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        titleTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 0.40).active = true
        
        //need x, y, width, height constraints
        titleSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        titleSeparatorView.topAnchor.constraintEqualToAnchor(titleTextField.bottomAnchor).active = true
        titleSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        titleSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        //need x, y, width, height constraints
        descriptionTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        descriptionTextField.topAnchor.constraintEqualToAnchor(titleSeparatorView.bottomAnchor).active = true
        
        descriptionTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
//        descriptionTextField.bottomAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor).active = true
        descriptionTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 0.60).active = true

        
//        //need x, y, width, height constraints
//        descriptionSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
//        descriptionSeparatorView.topAnchor.constraintEqualToAnchor(descriptionTextField.bottomAnchor).active = true
//        descriptionSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
//        descriptionSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
//        
        //need x, y, width, height constraints

    }

    func setupAddViewTitle() {
        addViewTitle.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        addViewTitle.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -50).active = true
        addViewTitle.widthAnchor.constraintEqualToConstant(300).active = true
        addViewTitle.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        takePhoto.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        takePhoto.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
        takePhoto.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        takePhoto.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    func submitItem() {
        if let user = FIRAuth.auth()?.currentUser {
            //user is signed in, now add the item with all its attributes
            let userId = user.uid
            let itemRef = FIRDatabase.database().reference().child("items")
            let newItemRef = itemRef.childByAutoId()
            let key = newItemRef.key
            if (titleTextField.text == "") || (descriptionTextField.text == "Describe your item") || (descriptionTextField.text == "") {
                print("error Add item")
            } else {
                let imageName = NSUUID().UUIDString
                let storageRef = FIRStorage.storage().reference().child("\(imageName).jpg")
                if (itemImage == nil) {
                    print("error Take photo")
                } else {
                    if let uploadData = UIImageJPEGRepresentation(itemImage!,0.4) {
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            if(error != nil) {
                                print("image upload error")
                                print(error)
                                return
                            }
                            if let imageUrl = metadata?.downloadURL()?.absoluteString {
                                print(imageUrl)
                                let contentRef = [
                                    "title":self.titleTextField.text as! AnyObject,
                                    "description":self.descriptionTextField.text as! AnyObject,
                                    "imageUrl":imageUrl,
                                    "userId":userId
                                ]
                                newItemRef.setValue(contentRef)
                            }
                            
                        })
                        let ref = FIRDatabase.database().referenceFromURL("https://tradey2-0.firebaseio.com/")
                        let userRefItem = ref.child("users").child(userId).child("items").childByAutoId()
                        userRefItem.setValue(key)
                        
                    }
                    home()
                }
            }
        } else {
            //user is not signed in
            print("error: user is not signed in")
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        
        var selectedImageFromPicker: UIImage?
        
        if let edittedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = edittedImage
            print("editted image")
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
            print("original image")
            print(originalImage)
        }
        if let selectedImage: UIImage = selectedImageFromPicker {
            print("here")
            print(selectedImage)
            itemImage = selectedImage
            print("below setting selectedImage")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField:UITextField!) -> Bool {
        
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    

}
