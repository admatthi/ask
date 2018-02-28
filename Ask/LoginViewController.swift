//
//  LoginViewController.swift
//  Ask
//
//  Created by Alek Matthiessen on 2/18/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstnametextfield: UITextField!
    @IBOutlet weak var errorlabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var tapEnter: UIButton!
    @IBAction func tapTermsPolicy(_ sender: Any) {
        
        if let url = NSURL(string: "http://www.justaskapp.com/privacy.html"
            ) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    @IBAction func pressEnter(_ sender: Any) {
        
        signinwithemail()
        errorlabel.alpha = 0
    }
    
    func signinwithemail() {
        
        if emailTextField.text != "" && passwordTextField.text != "" && firstnametextfield.text != ""{
            
            var password = passwordTextField.text!
            
            var email = emailTextField.text!
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if let error = error {

                    self.createaccountwithemail()
                    
                    return
                    
                } else {
                    
                    uid = (Auth.auth().currentUser?.uid)!
                    
            ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        var value = snapshot.value as? NSDictionary
                        
                        if var yes = value?["Purchased"] as? String {
                            
                            if yes == "True" {
                                
                                didpurchase = true
                                self.performSegue(withIdentifier: "LoginToCompanyHome", sender: self)
                                
                            } else {
                                
                                
                                didpurchase = false
                                self.performSegue(withIdentifier: "LoginToPurchase", sender: self)
                                firstname = self.firstnametextfield.text!

                            }
                            
                        } else {
                            
                            didpurchase = false
                            self.performSegue(withIdentifier: "LoginToPurchase", sender: self)
                            firstname = self.firstnametextfield.text!

                        }
                        
                    })
                    
                    
                }
            }
        }
        
    }
    

    func createaccountwithemail() {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            var email = emailTextField.text!
            var password = passwordTextField.text!

            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    
                    self.errorlabel.text = error.localizedDescription
                    
                    self.errorlabel.alpha = 1
                    
                    
                    return
                    
                } else {
                    
                    uid = (Auth.auth().currentUser?.uid)!
                    
                    ref?.child("Users").child(uid).updateChildValues(["Email" : email, "Password" : password])
                    
                    firstname = self.firstnametextfield.text!
                    
                    self.performSegue(withIdentifier: "LoginToPurchase", sender: self)
                    
                }
            }
            
            
        } else {
            
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        errorlabel.alpha = 0
        emailTextField.delegate = self
        passwordTextField.delegate = self

        firstnametextfield.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
