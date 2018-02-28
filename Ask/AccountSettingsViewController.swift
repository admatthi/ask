//
//  AccountSettingsViewController.swift
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

var comingfromlaunch = Bool()

class AccountSettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taplogout: UIButton!
    @IBOutlet weak var cvctf: UITextField!
    @IBOutlet weak var expdatetf: UITextField!
    @IBOutlet weak var creditcardtf: UITextField!
    @IBOutlet weak var lastnametf: UITextField!
    @IBOutlet weak var firstnametf: UITextField!
    @IBOutlet weak var emailaddresstextfield: UITextField!
    @IBOutlet weak var tapsave: UIButton!
    @IBOutlet weak var errorlabel: UILabel!
    @IBAction func tapSave(_ sender: Any) {
        
        if lastnametf.text != "" && firstnametf.text != "" && creditcardtf.text != "" && expdatetf.text != "" && cvctf.text != "" && emailaddresstextfield.text != "" {

        ref?.child("Users").child(uid).updateChildValues(["Email" : emailaddresstextfield.text!, "FirstName" : firstnametf.text!, "LastName" : lastnametf.text!, "CreditCard" : creditcardtf.text!, "ExpDate" : expdatetf.text!, "CVC" : cvctf.text!])
            
            self.performSegue(withIdentifier: "AccountToCampaignOverview", sender: self)
            
        } else {
            
            
        }
    }
    
    @IBAction func tapLogout(_ sender: Any) {
        
        try! Auth.auth().signOut()

        self.performSegue(withIdentifier: "LogoutToLogin", sender: self)
    }
    func queryforuserdata() {
        
        ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var yes = value?["FirstName"] as? String {
                
                self.firstnametf.text = yes
            }
            
            if var a = value?["LastName"] as? String {
                
                self.lastnametf.text = a
            }

            if var b = value?["CreditCard"] as? String {
                
                self.creditcardtf.text = b
            }

            if var c = value?["CVC"] as? String {
                
                self.cvctf.text = c
            }

            if var d = value?["ExpDate"] as? String {
                
                self.expdatetf.text = d
            }
            
            if var e = value?["Email"] as? String {
                
                self.emailaddresstextfield.text = e
            }


            if self.lastnametf.text != "" && self.firstnametf.text != "" && self.creditcardtf.text != "" && self.expdatetf.text != "" && self.cvctf.text != "" && self.emailaddresstextfield.text != "" {
                
                self.tapsave.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

            }
            

            
        })
        
    }
    
    @IBOutlet weak var accountlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        queryforuserdata()
        errorlabel.alpha = 0
        
        if comingfromlaunch == true {
            
            emailaddresstextfield.alpha = 0
            accountlabel.text = "Total Amount: \(pressedcost)"
            taplogout.alpha = 0
            tapsave.setTitle("Launch", for: .normal)
            comingfromlaunch = false

        } else {
            
            emailaddresstextfield.alpha = 1
            taplogout.alpha = 1
            accountlabel.text = "Email Address"
            tapsave.setTitle("Save", for: .normal)
            accountlabel.alpha = 1
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if lastnametf.text != "" && firstnametf.text != "" && creditcardtf.text != "" && expdatetf.text != "" && cvctf.text != ""  {
            
            tapsave.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)
            
        } else {
            
            tapsave.setBackgroundImage(UIImage(named: "GreyRectangle"), for: .normal)

        }
        
        return true
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
