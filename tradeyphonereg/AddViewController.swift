//
//  AddViewController.swift
//  tradeyphonereg
//
//  Created by Abdulqader Almetwali on 2016-07-09.
//  Copyright © 2016 abdul. All rights reserved.
//

import UIKit
import Firebase
import UIKeyboardLikePickerTextField

class AddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var itemImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.05, green:0.1, blue:0.15, alpha:1.0)
        
        descriptionTextField.text = "Describe your item"
        descriptionTextField.textColor = UIColor.lightGray
        
        view.addSubview(inputsContainerView)
        view.addSubview(takePhoto)
        view.addSubview(addViewTitle)
        view.addSubview(pickerTextField)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupAddViewTitle()
        setupPickerTextField()
        print("AddnewItem")
        // Do any additional setup after loading the view
        self.navigationController!.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitItem))

    }
    
    lazy var pickerTextField: UIKeyboardLikePickerTextField = {
        let picker = UIKeyboardLikePickerTextField()
        picker.delegate = self
        picker.pickerDataSource = ["Transportation", "Electronics", "Furniture", "Other"]
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.layer.masksToBounds = false
        picker.layer.cornerRadius = 10
//        picker.textColor = UIColor.whiteColor()
        
        picker.text = "Choose Category"
        picker.textAlignment = .center
        picker.backgroundColor = UIColor.white
        return picker
    }()
    
    func setupPickerTextField() {
        pickerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerTextField.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor,constant: 12).isActive = true
        pickerTextField.widthAnchor.constraint(equalTo: takePhoto.widthAnchor).isActive = true
        pickerTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let addViewTitle: UILabel = {
        let label = UILabel()
        label.text = "Create Item"
        label.textColor = UIColor.white
        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var takePhoto: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Take Photo", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(openCam), for: .touchUpInside)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("did begin editing")
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func openCam() {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your item"
            textView.textColor = UIColor.lightGray
        }
    }
    
    let descriptionSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func home() {
        let itemsViewController = ItemsViewController()
        itemsViewController.resetAllButtons()
        itemsViewController.navigationItem.title = "All"
        let navigationController = UINavigationController(rootViewController: itemsViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func back() {
        dismiss(animated: true, completion: nil)
    }

    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputsContainerView.addSubview(titleTextField)
        inputsContainerView.addSubview(titleSeparatorView)
        inputsContainerView.addSubview(descriptionTextField)
//        inputsContainerView.addSubview(descriptionSeparatorView)
        
        //need x, y, width, height constraints
        titleTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        titleTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        titleTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0.40).isActive = true
        
        //need x, y, width, height constraints
        titleSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        titleSeparatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        titleSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        titleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        descriptionTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        descriptionTextField.topAnchor.constraint(equalTo: titleSeparatorView.bottomAnchor).isActive = true
        
        descriptionTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        descriptionTextField.bottomAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor).active = true
        descriptionTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0.60).isActive = true

        
//        //need x, y, width, height constraints
//        descriptionSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
//        descriptionSeparatorView.topAnchor.constraintEqualToAnchor(descriptionTextField.bottomAnchor).active = true
//        descriptionSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
//        descriptionSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
//        
        //need x, y, width, height constraints

    }

    func setupAddViewTitle() {
        addViewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addViewTitle.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -50).isActive = true
        addViewTitle.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addViewTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        takePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takePhoto.topAnchor.constraint(equalTo: pickerTextField.bottomAnchor, constant: 12).isActive = true
        takePhoto.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        takePhoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func submitItem() {
        if let user = FIRAuth.auth()?.currentUser {
            //user is signed in, now add the item with all its attributes
            let userId = user.uid
            let itemRef = FIRDatabase.database().reference().child("items")
            let newItemRef = itemRef.childByAutoId()
            let key = newItemRef.key
            if (titleTextField.text == "") || (descriptionTextField.text == "Describe your item") || (descriptionTextField.text == "" || pickerTextField.text == "Choose Category" || (pickerTextField.text != "Electronics" && pickerTextField.text != "Furniture" && pickerTextField.text != "Other" && pickerTextField.text != "Transportation")) {
                print("error Add item or Category")
            } else {
                let imageName = UUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("\(imageName).jpg")
                if (itemImage == nil) {
                    print("error Take photo")
                } else {
                    if let uploadData = UIImageJPEGRepresentation(itemImage!,0.4) {
                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                            if(error != nil) {
                                print("image upload error")
                                print(error)
                                return
                            }
                            if let imageUrl = metadata?.downloadURL()?.absoluteString {
                                print(imageUrl)
                                let timestamp: NSNumber = NSNumber(value:Int(Date().timeIntervalSinceReferenceDate))
                                let contentRef = [
                                    "title":self.titleTextField.text as AnyObject,
                                    "description":self.descriptionTextField.text as AnyObject,
                                    "imageUrl":imageUrl,
                                    "userId":userId,
                                    "timestamp": timestamp,
                                    "category": self.pickerTextField.text! as String
                                ] as [String : Any]
                                newItemRef.setValue(contentRef)
                            }
                            
                        })
                        let ref = FIRDatabase.database().reference(fromURL: "https://tradey2-0.firebaseio.com/")
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField:UITextField!) -> Bool {
        
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        pickerTextField.resignFirstResponder()
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    

}
