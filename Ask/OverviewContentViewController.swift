//
//  OverviewContentViewController.swift
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

class OverviewContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func queryforcontentids(completed: @escaping (() -> ()) ) {
        
        contentids.removeAll()
        contentno.removeAll()
        contentyes.removeAll()
        contenttotals.removeAll()
        contentcost.removeAll()
        contentimages.removeAll()
        contenttitles.removeAll()
        
        var functioncounter = 0
        
        ref?.child("Content").child(selectedgroupid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            for each in postDict {
                
                let ids = each.key
                
                contentids.append(ids)
                
                functioncounter += 1
                
                if functioncounter == postDict.count {
                    
                    completed()
                }
            }
            
        })
    }
    
    func queryforcontentdata() {
        
        var functioncounter = 0
        
        for each in contentids {
            
            ref?.child("ContentData").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var value = snapshot.value as? NSDictionary
                
                if var yes = value?["Yes"] as? String {
                    
                    contentyes[each] = yes
                }
                
                if var no = value?["No"] as? String {
                    
                    contentno[each] = no
                }
                
                if var type = value?["Type"] as? String {
                    
                    if type == "True" {
                        
                        if var title = value?["Title"] as? String {
                            
                            contenttitles[each] = title
                        }
                        if var productimagee = value?["Image"] as? String {
                            
                            if productimagee.hasPrefix("http://") || productimagee.hasPrefix("https://") {
                                
                                let url = URL(string: productimagee)
                                
                                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                                
                                if data != nil {
                                    
                                    let productphoto = UIImage(data: (data)!)
                                    
                                    contentimages[each] = productphoto
                                    
        
                                }
                                
                                
                            }
                        }
                        
                    } else {
                        
                        if var title = value?["Title"] as? String {
                            
                            contenttitles[each] = title
                            contentimages[each] = nil
                        }

                    }
                }
                
                if var cost = value?["Cost"] as? String {
                    
                    contentcost[each] = cost
                }
                
                if var total = value?["Total"] as? String {
                    
                    contenttotals[each] = total
                    
                }
                

                functioncounter += 1
                
                if functioncounter == contentids.count {
                    
                    self.hideloading()
                    self.tableView.reloadData()
                    
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
            headerlabel.text = "\(grouptitles[selectedgroupid]!) -- \(campaigntitles[selectedcampaignid]!)"

            queryforcontentids {
                
                self.queryforcontentdata()
            }
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if contenttitles.count > 0 {
            
            return contenttitles.count
            
        } else {
            
            return 1
        }
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Results", for: indexPath) as! ResultsTableViewCell
        
        if contenttitles.count > indexPath.row {
            
            cell.campaignyestext.text = "\(contentyes[contentids[indexPath.row]]!)"
            
            cell.campaignnotext.text = "\(contentno[contentids[indexPath.row]]!)"
            
            cell.campaigntotaltext.text = "\(contenttotals[contentids[indexPath.row]]!)"
            
            cell.campaigncosttext.text = "\(contentcost[contentids[indexPath.row]]!)"
            
            if contentimages[contentids[indexPath.row]] != nil {
                
                cell.contentimage.image = contentimages[contentids[indexPath.row]]
                cell.campaigntitletext.alpha = 0
                
            } else {
                
                cell.contentimage.alpha = 0
                cell.campaigntitletext.text = "\(contenttitles[contentids[indexPath.row]]!)"
            }
            
            
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
        
        
        selectedcontent = contentids[indexPath.row]
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "ContentToPieceOfContent", sender: self)
            
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

