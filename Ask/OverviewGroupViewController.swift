//
//  OverviewGroupViewController.swift
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

class OverviewGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tapback: UIButton!
    @IBAction func tapBackButton(_ sender: Any) {
        
        
    }
    @IBAction func tapHome(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "GroupOverviewToCampaignOverview", sender: self)
            
        }
    }
    func queryforgroupids(completed: @escaping (() -> ()) ) {
        
        groupids.removeAll()
        groupno.removeAll()
        groupyes.removeAll()
        grouptotals.removeAll()
        groupcost.removeAll()
        grouptitles.removeAll()
        
        var functioncounter = 0
        
        ref?.child("Groups").child(selectedcampaignid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            for each in postDict {
                
                let ids = each.key
                
                groupids.append(ids)
                
                functioncounter += 1
                
                if functioncounter == postDict.count {
                    
                    completed()
                }
            }
            
        })
    }
    
    func queryforgroupdata() {
        
        var functioncounter = 0
        
//        var minagequery = String()
//        var maxagequery = String()
//        var gendery query = String()
//        
        for each in groupids {
            
            ref?.child("GroupData").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var yes = value?["Yes"] as? String {
                    
                    groupyes[each] = yes
                }
                
                if var no = value?["No"] as? String {
                    
                    groupno[each] = no
                }
                
                if var title = value?["Title"] as? String {
                    
                    grouptitles[each] = title
                }
                
                if var cost = value?["Cost"] as? String {
                    
                    groupcost[each] = cost
                }
                
                if var total = value?["Total"] as? String {
                    
                    grouptotals[each] = total
                    
                }
                
//                if var total = value?["MinAge"] as? String {
//                    
//                    grouptotals[each] = total
//                    
//                }
//                
//                if var total = value?["MaxAge"] as? String {
//                    
//                    grouptotals[each] = total
//                    
//                }
//                
//                if var total = value?["Gender"] as? String {
//                    
//                    grouptotals[each] = total
//                    
//                }
                
                functioncounter += 1
                
                if functioncounter == groupids.count {
                    
                    self.tableView.reloadData()
                    
                    self.hideloading()
                    
                }
                
                
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser == nil {
            // Do smth if user is not logged in
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "CompanyHomeToLogin", sender: self)
                
            }
            
            
        } else {
            
            uid = (Auth.auth().currentUser?.uid)!
            
            showloading()
            headerlabel.text = campaigntitles[selectedcampaignid]
            
            queryforgroupids {
                
                self.queryforgroupdata()
            }
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if grouptitles.count > 0 {
            
            return grouptitles.count
            
        } else {
            
            return 1
        }
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Results", for: indexPath) as! ResultsTableViewCell
        
        
        if grouptitles.count > indexPath.row {
                                    
            cell.campaignyestext.text = "\(groupyes[groupids[indexPath.row]]!)"
            
            cell.campaigntitletext.text = "\(grouptitles[groupids[indexPath.row]]!)"
            
            cell.campaignnotext.text = "\(groupno[groupids[indexPath.row]]!)"
            
            cell.campaigntotaltext.text = "\(grouptotals[groupids[indexPath.row]]!)"
            
            cell.campaigncosttext.text = "\(groupcost[groupids[indexPath.row]]!)"
            
            
        } else {
            
//            cell.campaigntitle.text = "No Groups"
//
//            cell.campaignyes.text = ""
//
//            cell.campaignno.text = ""
//
//            cell.campaigntotal.text = ""
//
//            cell.campaigncost.text = ""
            
        }
        
        
        return cell
        
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
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        
        
        selectedgroupid = groupids[indexPath.row]
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "GroupToContent", sender: self)
            
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

