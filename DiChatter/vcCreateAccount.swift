//
//  vcCreateAccount.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/12/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class vcCreateAccount: UIViewController {
    
    var ref: FIRDatabaseReference!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var numberTextView: UITextField!
    
    var gender = "male"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add border to all textviews
        addBorderToTextView(incomingField: nameTextView)
        addBorderToTextView(incomingField: emailTextView)
        addBorderToTextView(incomingField: passwordTextView)
        addBorderToTextView(incomingField: numberTextView)
        
        //add image to all textviews
        addImageTextView(textView: nameTextView, image: #imageLiteral(resourceName: "nameWhite"))
        addImageTextView(textView: emailTextView, image: #imageLiteral(resourceName: "emailWhite"))
        addImageTextView(textView: passwordTextView, image: #imageLiteral(resourceName: "passwordWhite"))
        addImageTextView(textView: numberTextView, image: #imageLiteral(resourceName: "phoneWhite"))
        
        //Intitalize the database
        ref = FIRDatabase.database().reference();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Image Maker
    func addImageTextView(textView: UITextField, image: UIImage) {
        textView.leftViewMode = UITextFieldViewMode.always
        let eImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        eImageView.image = image
        textView.leftView = eImageView
    }
    
    //Border maker
    func addBorderToTextView(incomingField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: incomingField.frame.size.height - width,
                              width:  incomingField.frame.size.width, height: incomingField.frame.size.height)
        border.borderWidth = width
        incomingField.layer.addSublayer(border)
        incomingField.layer.masksToBounds = true
    }
    
    
    //Actions: Buttons and Segement
    @IBAction func genderSelection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            gender = "male"
            break
        case 1:
            gender = "female"
            break;
        default:
            break;
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if nameTextView.text == "" || emailTextView.text == "" || passwordTextView.text == "" {
            makeAlert(title: "Incomplete Date", message: "Please complete all the fields approriately.")
            //makeDummyUsers()
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailTextView.text!, password: passwordTextView.text!, completion: { (user, error) in
                if error == nil {
                    let userId: String = (user?.uid)!
                    let userName: String = self.nameTextView.text!
                    let userEmail: String = self.emailTextView.text!
                    let userNumber: String = self.numberTextView.text!
                    let userGender: String = self.gender
                    
                    //upload data to databse
                    self.ref.child("Users").child(userId).setValue(["Name": userName, "Email": userEmail, "Number": userNumber, "Gender": userGender])
                    
                    //transition to next screen and send data
                    self.performSegue(withIdentifier: "segueCAtoMain", sender: nil)
                } else {
                    self.makeAlert(title: "Error", message: (error?.localizedDescription)!)
                }
            })
        }
    }
    
    func makeDummyUsers() {
        for i in 0...10 {
            FIRAuth.auth()?.createUser(withEmail: "User" + String(i) + "@yahoo.com", password: "123456", completion: { (user, error) in
                if error == nil {
                    let userId: String = (user?.uid)!
                    let userName: String = "User" + String(i)
                    let userEmail: String = "User" + String(i) + "@yahoo.com"
                    let userNumber: String = String(123456789)
                    let userGender: String = self.gender
                    
                    //upload data to databse
                    self.ref.child("Users").child(userId).setValue(["Name": userName, "Email": userEmail, "Number": userNumber, "Gender": userGender])
                } else {
                    self.makeAlert(title: "Error", message: (error?.localizedDescription)!)
                }
            })
        }
        makeAlert(title: "Success", message: "User Created!")
    }
    
    
    //make alerts
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated:true, completion: nil)
    }
}



//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "segueCAtoMain") {
//            let svc = segue.destination as! mainController;
//            svc.userInfo = self.userInfo
//        }
//    }
