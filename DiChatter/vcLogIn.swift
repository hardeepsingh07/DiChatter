//
//  ViewController.swift
//  DiChatter
//
//  Created by Hardeep Singh on 12/10/16.
//  Copyright © 2016 Hardeep Singh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class vcLogin : UIViewController {
    
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    var userInfo: UserInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        emailTextView.text = "hardeep07@yahoo.com"
//        passwordTextView.text = "123456"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueLItoMain") {
            let svc = segue.destination as! mainController;
            svc.userInfo = self.userInfo
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Button Actions
    @IBAction func signIn(_ sender: Any) {
        login()
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        makeAlert(title: "Notice", message: "Under Construction")
    }
    
    
    @IBAction func createNewAccount(_ sender: Any) {
        //Move to next activity
        self.performSegue(withIdentifier: "segueCreateAccount", sender: nil)
    }
    
    
    func createAccount() {
        FIRAuth.auth()?.createUser(withEmail: "email", password: "password", completion: { (user, error) in
            if error == nil {
            } else {
                self.makeAlert(title: "Error", message: (error?.localizedDescription)!)
            }
        })
    }
    
    func login()  {
        if emailTextView.text == "" || passwordTextView.text == "" {
            makeAlert(title: "Incomplete Date", message: "Please enter both email and password.")
        } else {
            FIRAuth.auth()?.signIn(withEmail: emailTextView.text!, password: passwordTextView.text!, completion: { (user, error) in
                if error == nil {
                    //move to next activity and send data
                    self.emailTextView.text = ""
                    self.passwordTextView.text = ""
                    self.performSegue(withIdentifier: "segueLItoMain", sender: nil)
                } else {
                    self.makeAlert(title: "Error", message: (error?.localizedDescription)!)
                }
            })
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated:true, completion: nil)
    }
}

//    func addImageTextView(textView: UITextField, image: UIImage) {
//        textView.leftViewMode = UITextFieldViewMode.always
//        let eImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        eImageView.image = image
//        textView.leftView = eImageView
//    }
//
//    func addBorderToTextView(incomingField: UITextField) {
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = UIColor.white.cgColor
//        border.frame = CGRect(x: 0, y: incomingField.frame.size.height - width,
//                              width:  incomingField.frame.size.width, height: incomingField.frame.size.height)
//        border.borderWidth = width
//        incomingField.layer.addSublayer(border)
//        incomingField.layer.masksToBounds = true
//    }


