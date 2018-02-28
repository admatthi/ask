//
//  CreateGroupViewController.swift
//  Ask
//
//  Created by Alek Matthiessen on 2/18/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit

var pressedgender = String()

var pressedcost = String()
var pressedminage = String()
var pressedmaxage = String()
var pressedresponses = String()


class CreateGroupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tapcontinue: UIButton!
    @IBOutlet weak var totallabel: UILabel!
    @IBOutlet weak var responsenumber: UITextField!
    @IBOutlet weak var maxage: UITextField!
    @IBOutlet weak var minage: UITextField!
    @IBOutlet weak var tapfemale: UIButton!
    @IBOutlet weak var tapmale: UIButton!
    
    @IBOutlet weak var tapobjective: UIButton!
    
    @IBAction func tapObjective(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CreateGroupToCreateObjective", sender: self)
    }
    @IBAction func tapFemale(_ sender: Any) {
        
        tapfemale.setTitleColor(.white, for: .normal)
        tapmale.setTitleColor(.black, for: .normal)
        tapmale.setBackgroundImage(UIImage(named: "GrayRectangle"), for: .normal)
        tapfemale.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)
        
        pressedgender = "Female"
        
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)
        
    }
    @IBAction func tapMale(_ sender: Any) {
        
        tapfemale.setTitleColor(.black, for: .normal)
        tapmale.setTitleColor(.white, for: .normal)
        tapmale.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)
        tapfemale.setBackgroundImage(UIImage(named: "GrayRectangle"), for: .normal)
        
        pressedgender = "Male"
        
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)
    }
    @IBAction func tapContinue(_ sender: Any) {
        
        if pressedgender == "" {
            
            
        } else {
        
        calculatecost()
        
        pressedresponses = responsenumber.text!
        pressedminage = minage.text!
        pressedmaxage = maxage.text!
        
        self.performSegue(withIdentifier: "CreateGroupToCreateContent", sender: self)
            
        }
    }
    
    func calculatecost() {
        
        var totalcost = Double(responsenumber.text!)! * 0.05
        
        let price = totalcost as NSNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // formatter.locale = NSLocale.currentLocale() // This is the default
        // In Swift 4, this ^ has been renamed to simply NSLocale.current
        formatter.string(from: price) // "$123.44"
        
        pressedcost = formatter.string(from: price)!
        
        var stringtotalcost = formatter.string(from: price)
        
        totallabel.text = "\(formatter.string(from: price)!)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        maxage.delegate = self
        minage.delegate = self
        responsenumber.delegate = self
        // Do any additional setup after loading the view.
        
        if pressedgender == "" {
            
            
        } else {
            
            if pressedgender == "Male" {
                
                
                tapfemale.setTitleColor(.black, for: .normal)
                tapmale.setTitleColor(.white, for: .normal)
                tapmale.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)
                tapfemale.setBackgroundImage(UIImage(named: "GrayRectangle"), for: .normal)
                tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

                
            } else {
                
                tapfemale.setTitleColor(.white, for: .normal)
                tapmale.setTitleColor(.black, for: .normal)
                tapmale.setBackgroundImage(UIImage(named: "GrayRectangle"), for: .normal)
                tapfemale.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)
                
                tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

            }
            
            maxage.text = pressedmaxage
            minage.text = pressedminage
            responsenumber.text = pressedresponses
            calculatecost()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
        calculatecost()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        calculatecost()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        calculatecost()

        pressedresponses = responsenumber.text!
        pressedminage = minage.text!
        pressedmaxage = maxage.text!
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        calculatecost()
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

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
