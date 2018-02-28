//
//  AppDelegate.swift
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
import UserNotifications
import Appsee
import SwiftyStoreKit
import StoreKit

var ref: DatabaseReference?
var uid = String()

var campaignids = [String]()
var campaigntitles = [String:String]()
var campaignyes = [String:String]()
var campaignno = [String:String]()
var campaigntotals = [String:String]()
var campaigncost = [String:String]()

var selectedcampaignid = String()

var groupids = [String]()
var grouptitles = [String:String]()
var groupyes = [String:String]()
var groupno = [String:String]()
var grouptotals = [String:String]()
var groupcost = [String:String]()

var selectedgroupid = String()

var contentids = [String]()
var contenttitles = [String:String]()
var contentyes = [String:String]()
var contentno = [String:String]()
var contenttotals = [String:String]()
var contentcost = [String:String]()
var contentimages = [String:UIImage]()

var selectedcontent = String()

var firstname = String()
var email = String()
var password = String()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        Appsee.start("c693e035a56547669ab524f3b2649e10")

        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            
            for product in products {
                
                if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
                    
                    if product.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                    print("purchased: \(product)")
                }
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

