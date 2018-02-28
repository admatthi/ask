//
//  PurchaseViewController.swift
//  Ask
//
//  Created by Alek Matthiessen on 2/24/18.
//  Copyright © 2018 AA Tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import UserNotifications
import SwiftyStoreKit
import StoreKit

var trialselected = Bool()
var annualselected = Bool()

enum RegisteredPurchase: String {
    
    case trial = "SevenDayFreeTrial"
    
    case AnnualSub = "YearSubscription"
    
    case autoRenewable = "autoRenewable"

}

class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        loadingCount += 1
    }
    
    class func networkOperationFinished() {
        
        if loadingCount > 0 {
            
            loadingCount -= 1
            
        }
        
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

        }
    }
}

var sharedSecret = "53eaadbc314a47d39b27893d1e4f692e"

var price = Double()

class PurchaseViewController: UIViewController {


    @IBOutlet weak var welcomelabel: UILabel!
    @IBOutlet weak var tapcontinue: UIButton!
    @IBOutlet weak var taprestore: UIButton!
    @IBOutlet weak var tappurchaseyear: UIButton!
    @IBOutlet weak var tappurchasetrial: UIButton!
    
    let bundleID = "com.aatech.Ask"
    
    var Trial = RegisteredPurchase.trial
    var Annual = RegisteredPurchase.AnnualSub
    let validator = AppleReceiptValidator(service: .production)

    @IBAction func tapRestore(_ sender: Any) {
        
        restorePurchases()
        
    }
    @IBAction func tapPurchaseTrial(_ sender: Any) {
        
        trialselected = true
        annualselected = false
    }
    @IBAction func tapContinue(_ sender: Any) {
        
        if trialselected == false {
            
            purchase(purchase: Annual)

        } else {
                        
            purchase(purchase: Trial)
        }
    }
    @IBAction func tapPurchaseYear(_ sender: Any) {
        
        annualselected = true
        trialselected = false
    }
    
    func getInfo(purchase : RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.rawValue], completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
            
            
        })
    }

        
    func purchase(purchase : RegisteredPurchase) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateresult = formatter.string(from: date)
            NetworkActivityIndicatorManager.NetworkOperationStarted()
        
        
            SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.rawValue,
                            completion: {
                result in
                NetworkActivityIndicatorManager.networkOperationFinished()
                
                if case .success(let product) = result {
                    
                    if product.productId == self.bundleID + "." + "SevenDayFreeTrial"{
                        
                        price = 34.99
                        
                    }
                    if product.productId == self.bundleID + "." + "YearSubscription" {
                        
                        price = 399.99

                    }
                    
                    if product.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                    
                    ref?.child("Users").child(uid).updateChildValues(["Purchased": "True", "PurchasedDate" : dateresult])
                    
//                    self.showAlert(alert: self.alertForPurchaseResult(result: result))
                    
                    DispatchQueue.main.async {
                        
                        self.performSegue(withIdentifier: "PurchaseToHome", sender: self)

                    }

                }
                
            })
            
        }

    
    func restorePurchases() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
            
        })
    }
    
    func verifyReceipt() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: validator, password: sharedSecret, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(alert: self.alertForVerifyReceipt(result: result))
            
            if case .error(let error) = result {
                if case .noReceiptData = error {
                    


                }
            }
            
        })
        
    }
    
    func verifyPurchase(product : RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: validator, password: sharedSecret, completion: {
            result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
                
            case .success(let receipt):
                
                let productID = self.bundleID + "." + product.rawValue
                
                if product == .autoRenewable {
                    let purchaseResult = SwiftyStoreKit.verifySubscription(type: .autoRenewable, productId: productID, inReceipt: receipt, validUntil: Date())
                    self.showAlert(alert: self.alertForVerifySubscription(result: purchaseResult))
                    
                }
                else {
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                    self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
                    
                }
            case .error(let error):
                self.showAlert(alert: self.alertForVerifyReceipt(result: result))
                if case .noReceiptData = error {

                }
                
            }
            
            
        })
        
    }
    

    @IBAction func tapTerms(_ sender: Any) {
        
        if let url = NSURL(string: "http://www.justaskapp.com/privacy.html"
            ) {
            UIApplication.shared.openURL(url as URL)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        welcomelabel.text = "Welcome \(firstname)!"
        
        trialselected = true 
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

    func alertWithTitle(title : String, message : String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
        
    }
    func showAlert(alert : UIAlertController) {
        guard let _ = self.presentedViewController else {
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    func alertForProductRetrievalInfo(result : RetrieveResults) -> UIAlertController {
        
        
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
            
        }
        else if let invalidProductID = result.invalidProductIDs.first {
            return alertWithTitle(title: "Could not retreive product info", message: "Invalid product identifier: \(invalidProductID)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unknown Error. Please Contact Support"
            return alertWithTitle(title: "Could not retreive product info" , message: errorString)
            
        }
        
    }
    func alertForPurchaseResult(result : PurchaseResult) -> UIAlertController {
        
        
        switch result {
            
        case .success(let product):
            print("Purchase Succesful: \(product.productId)")
            
            return alertWithTitle(title: "You're all set", message: "Your purchase was successful")
            

            

        case .error(let error):
            print("Purchase Failed: \(error)")
            
            switch error.code {
            case .unknown: return alertWithTitle(title: "Purchase Error", message: "Unknown error. Please contact support")
            case .clientInvalid: return alertWithTitle(title: "Purchase Error", message: "Not allowed to make the payment")
            case .paymentCancelled: return alertWithTitle(title: "Payment Cancelled", message: "Payment Cancelled")
            case .paymentInvalid: return alertWithTitle(title: "Purchase Error", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: return alertWithTitle(title: "Purchase Error", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: return alertWithTitle(title: "Purchase Error", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: return alertWithTitle(title: "Purchase Error", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: return alertWithTitle(title: "Purchase Error", message: "Could not connect to the network")
            default: return alertWithTitle(title: "Purchase Error", message: "Unknown error")
            }

        }
    }
    func alertForRestorePurchases(result : RestoreResults) -> UIAlertController {
        if result.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(result.restoreFailedPurchases)")
            return alertWithTitle(title: "Restore Failed", message: "Unknown Error. Please Contact Support")
        }
        else if result.restoredPurchases.count > 0 {
            
            //
            return alertWithTitle(title: "Purchases Restored", message: "All purchases have been restored.")
            
        }
        else {
            return alertWithTitle(title: "Nothing To Restore", message: "No previous purchases were made.")
        }
        
    }
    func alertForVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case.success(let receipt):
            return alertWithTitle(title: "Receipt Verified", message: "Receipt Verified Remotely")
        case .error(let error):
            switch error {
            case .noReceiptData:
                return alertWithTitle(title: "Receipt Verification", message: "No receipt data found, application will try to get a new one. Try Again.")
            default:
                return alertWithTitle(title: "Receipt verification", message: "Receipt Verification failed")
            }
        }
    }
    func alertForVerifySubscription(result: VerifySubscriptionResult) -> UIAlertController {
        switch result {
        case .purchased(let expiryDate):
            return alertWithTitle(title: "Product is Purchased", message: "Product is valid until \(expiryDate)")
        case .notPurchased:
            return alertWithTitle(title: "Not purchased", message: "This product has never been purchased")
        case .expired(let expiryDate):
            
            return alertWithTitle(title: "Product Expired", message: "Product is expired since \(expiryDate)")
        }
    }
    func alertForVerifyPurchase(result : VerifyPurchaseResult) -> UIAlertController {
        switch result {
        case .purchased:
            return alertWithTitle(title: "Product is Purchased", message: "Product will not expire")
        case .notPurchased:
            
            return alertWithTitle(title: "Product not purchased", message: "Product has never been purchased")
            
            
        }
        
    }
    func alertForRefreshRecepit(result : RefreshReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receiptData):
            return alertWithTitle(title: "Receipt Refreshed", message: "Receipt refreshed successfully")
        case .error(let error):
            return alertWithTitle(title: "Receipt refresh failed", message: "Receipt refresh failed")
            
            }
        }
    
    }





