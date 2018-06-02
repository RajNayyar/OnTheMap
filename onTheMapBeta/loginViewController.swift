//
//  loginViewController.swift
//  On the Map beta
//
//  Created by Rajpreet on 11/01/18.
//  Copyright © 2018 Rajpreet. All rights reserved.
//
//
import UIKit

class loginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailId: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBOutlet weak var signUpAction: UIButton!
    
    @IBAction func signUpAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if(emailId.text=="E-mail Id" || passwordText.text=="password" || emailId.text=="" || passwordText.text=="")
        {
            self.Error(error: "Please fill Email-Id and password!")
        }
        else
        {
        self.view.endEditing(true)
        udacityUser.sharedInstance().authentication(username: emailId.text!, password: passwordText.text!) { (result, error) in
            if error != nil {
                self.Error(error: error!)
            }
            else {
                DispatchQueue.main.async {
                let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "mapTable")
                    self.present(tabBar!, animated: true, completion: nil)                          // performing segue to next viewcontroller
                }
            }
        }
        }
    }

    func Error(error: String)
    {
        
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// for hiding keyboard when tapped anywhere on the screen.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



