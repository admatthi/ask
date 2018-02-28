//
//  OverviewCampaignViewController.swift
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

var timer = Timer()
var didpurchase = Bool()

class OverviewCampaignViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
 
    func queryforcampaignids(completed: @escaping (() -> ()) ) {
        
        var functioncounter = 0
        
        ref?.child("Campaigns").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if postDict.count > 0 {
                
            
            for each in postDict {
                
                let ids = each.key
                
                campaignids.append(ids)
                
                functioncounter += 1
                
                if functioncounter == postDict.count {
                    
                    completed()
                }
            }
                
            } else {
                
                
            }
            
        })
    }
    
    @IBOutlet weak var loadingbackground: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    func hideloading() {
        
        loadingbackground.alpha = 0
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
        
    }
    
    func showloading() {
        
        
        loadingbackground.alpha = 1
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
        
    }
    
    func queryforcampaigndata() {
        
        var functioncounter = 0
        
        if campaignids.count > 0 {


        for each in campaignids {
        
        ref?.child("CampaignData").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var yes = value?["Yes"] as? String {
                
                campaignyes[each] = yes
            }
            
            if var no = value?["No"] as? String {
                
                campaignno[each] = no
            }
            
            if var title = value?["Title"] as? String {
                
                campaigntitles[each] = title
            }
            
            if var cost = value?["Cost"] as? String {
                
                campaigncost[each] = cost
            }
            
            if var total = value?["Total"] as? String {
                
                campaigntotals[each] = total
                
            }
            
            functioncounter += 1
            
            if functioncounter == campaignids.count {
            
                self.tableView.reloadData()
                self.hideloading()
                
            }
            
            
        })

        }
            
        } else {
            
            self.tableView.reloadData()
            self.hideloading()
            
        }
    }
    

    func queryforpurchase(completed: @escaping (() -> ()) ) {
        
        ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            if var yes = value?["Purchased"] as? String {
                
                if yes == "True" {
                    
                    didpurchase = true
                    completed()
                } else {
                    
                    
                    didpurchase = false
                    completed()
                }
            
            } else {
                
                
                didpurchase = false
                completed()
                
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser == nil {
            // Do smth if user is not logged in
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "HomeToSales", sender: self)
                
            }
            
            
        } else {
            
            
            
            uid = (Auth.auth().currentUser?.uid)!
            
            showloading()
            
            campaignyes.removeAll()
            campaignno.removeAll()
            campaignids.removeAll()
            campaigntotals.removeAll()
            campaigncost.removeAll()
            campaigntitles.removeAll()
            
            count = 0
            
            queryforpurchase { () -> () in
                
                if didpurchase {
                    
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OverviewCampaignViewController.loadingout), userInfo: nil, repeats: true)
                self.queryforcampaignids {
                    
                    self.queryforcampaigndata()
                }
                    
                } else {
                    
                    self.performSegue(withIdentifier: "HomeToPurchase", sender: self)
                }
                
                
            }


            
        }
    }
    
    var count = Int()
    
    @objc func loadingout() {
        
        count += 1
        
        if count > 5 {
            
           queryforcampaigndata()
            
            timer.invalidate()
        }
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if campaigntitles.count > 0 {
            
            return campaigntitles.count
            
        } else {
            
            return 1
        }
        
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Results", for: indexPath) as! ResultsTableViewCell

        if campaigntitles.count > indexPath.row && campaignids.count == campaigntitles.count {
            
            print(campaignids)
            
            cell.campaigntitletext.text = "\(campaigntitles[campaignids[indexPath.row]]!)"
            
            cell.campaignyestext.text = "\(campaignyes[campaignids[indexPath.row]]!)"
            
            cell.campaignnotext.text = "\(campaignno[campaignids[indexPath.row]]!)"
            
            cell.campaigntotaltext.text = "\(campaigntotals[campaignids[indexPath.row]]!)"
            
            cell.campaigncosttext.text = "\(campaigncost[campaignids[indexPath.row]]!)"
            
            
        } else {
            
            cell.campaigntitletext.text = "No Campaigns"

            cell.campaignyestext.text = ""
            
            cell.campaignnotext.text = ""
            
            cell.campaigntotaltext.text = ""
            
            cell.campaigncosttext.text = ""
            
        }
        
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        
        
        selectedcampaignid = campaignids[indexPath.row]
            
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "CompanyHomeToGroup", sender: self)
//            var overview = self.storyboard?.instantiateViewController(withIdentifier: "OverviewGroup") as! OverviewGroupViewController
//
//            presentDetail(self.overview)
            
        }
        
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

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}
