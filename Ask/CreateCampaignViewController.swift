//
//  CreateCampaignViewController.swift
//  Ask
//
//  Created by Alek Matthiessen on 2/18/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit

let lightblue = UIColor(red:0.11, green:0.69, blue:0.91, alpha:1.0)

var objectivepressed = String()

class CreateCampaignViewController: UIViewController {

    @IBOutlet weak var tapcontinue: UIButton!
    
    @IBOutlet weak var tapconsideration1: UIButton!
    @IBOutlet weak var tapconsideration2: UIButton!
    @IBOutlet weak var tapawareness1: UIButton!
    @IBOutlet weak var tapconversion1: UIButton!
    @IBOutlet weak var tapconversion2: UIButton!
    @IBOutlet weak var tapconversion3: UIButton!
    @IBOutlet weak var tapconversion4: UIButton!
    
    @IBAction func tapContinue(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ObjectiveToAudience", sender: self)
    }
    @IBAction func tapConsidertion1(_ sender: Any) {
        
        objectivepressed = (tapconsideration1.titleLabel?.text!)!
        tapconsideration1.setTitleColor(lightblue, for: .normal)
        tapconsideration2.setTitleColor(.black, for: .normal)
        tapawareness1.setTitleColor(.black, for: .normal)
        tapconversion1.setTitleColor(.black, for: .normal)
        tapconversion2.setTitleColor(.black, for: .normal)
        tapconversion3.setTitleColor(.black, for: .normal)
        tapconversion4.setTitleColor(.black, for: .normal)
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)
    }
    @IBAction func tapConsideration2(_ sender: Any) {
        
        objectivepressed = (tapconsideration2.titleLabel?.text!)!
        tapconsideration1.setTitleColor(.black, for: .normal)
        tapconsideration2.setTitleColor(lightblue, for: .normal)
        tapawareness1.setTitleColor(.black, for: .normal)
        tapconversion1.setTitleColor(.black, for: .normal)
        tapconversion2.setTitleColor(.black, for: .normal)
        tapconversion3.setTitleColor(.black, for: .normal)
        tapconversion4.setTitleColor(.black, for: .normal)
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

    }
    @IBAction func tapConversation1(_ sender: Any) {
        objectivepressed = (tapconversion1.titleLabel?.text!)!
        tapconsideration1.setTitleColor(.black, for: .normal)
        tapconsideration2.setTitleColor(.black, for: .normal)
        tapawareness1.setTitleColor(.black, for: .normal)
        tapconversion1.setTitleColor(lightblue, for: .normal)
        tapconversion2.setTitleColor(.black, for: .normal)
        tapconversion3.setTitleColor(.black, for: .normal)
        tapconversion4.setTitleColor(.black, for: .normal)
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

    }
    @IBAction func tapConversion4(_ sender: Any) {
        objectivepressed = (tapconversion4.titleLabel?.text!)!
        tapconsideration1.setTitleColor(.black, for: .normal)
        tapconsideration2.setTitleColor(.black, for: .normal)
        tapawareness1.setTitleColor(.black, for: .normal)
        tapconversion1.setTitleColor(.black, for: .normal)
        tapconversion2.setTitleColor(.black, for: .normal)
        tapconversion3.setTitleColor(.black, for: .normal)
        tapconversion4.setTitleColor(lightblue, for: .normal)
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

    }
    @IBAction func tapConversion3(_ sender: Any) {
        objectivepressed = (tapconversion3.titleLabel?.text!)!
        tapconsideration1.setTitleColor(.black, for: .normal)
        tapconsideration2.setTitleColor(.black, for: .normal)
        tapawareness1.setTitleColor(.black, for: .normal)
        tapconversion1.setTitleColor(.black, for: .normal)
        tapconversion2.setTitleColor(.black, for: .normal)
        tapconversion3.setTitleColor(lightblue, for: .normal)
        tapconversion4.setTitleColor(.black, for: .normal)
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

    }
    
    @IBAction func tapConversion2(_ sender: Any) {
        objectivepressed = (tapconversion2.titleLabel?.text!)!
        tapconsideration1.setTitleColor(.black, for: .normal)
        tapconsideration2.setTitleColor(.black, for: .normal)
        tapawareness1.setTitleColor(.black, for: .normal)
        tapconversion1.setTitleColor(.black, for: .normal)
        tapconversion2.setTitleColor(lightblue, for: .normal)
        tapconversion3.setTitleColor(.black, for: .normal)
        tapconversion4.setTitleColor(.black, for: .normal)
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

    }
    @IBAction func tapAwareness1(_ sender: Any) {
        
        objectivepressed = (tapawareness1.titleLabel?.text!)!
        tapconsideration1.setTitleColor(.black, for: .normal)
        tapconsideration2.setTitleColor(.black, for: .normal)
        tapawareness1.setTitleColor(lightblue, for: .normal)
        tapconversion1.setTitleColor(.black, for: .normal)
        tapconversion2.setTitleColor(.black, for: .normal)
        tapconversion3.setTitleColor(.black, for: .normal)
        tapconversion4.setTitleColor(.black, for: .normal)
        tapcontinue.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tapconsideration1.setTitle("Attends Event", for: .normal)
        tapconsideration2.setTitle("App Installs", for: .normal)
        tapawareness1.setTitle("Brand Awareness", for: .normal)
        tapconversion1.setTitle("Purchases", for: .normal)
        tapconversion2.setTitle("Sign Ups", for: .normal)
        tapconversion3.setTitle("In Store Visits", for: .normal)
        tapconversion4.setTitle("Likes", for: .normal)
        
        
        if objectivepressed == "" {
            
            
        } else {
            
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
