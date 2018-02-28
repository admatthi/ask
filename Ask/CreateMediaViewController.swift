//
//  CreateMediaViewController.swift
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

var pressedcontent = [String:String]()
var pressedimages = [String]()
var pressedtext = [String]()

var uploadedimages = [UIImage]()
var uploadedtext = [String]()

class CreateMediaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var tapaddmedia: UIButton!
    @IBOutlet weak var tapaddcontent: UIButton!
    
    @IBOutlet weak var selectedimageview: UIImageView!
    @IBOutlet weak var taplaunch: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    var counter = Int()
    
    var stringimageurl = String()
    
    @IBOutlet weak var tapremove: UIButton!
    @IBOutlet weak var tapone: UIButton!
    @IBOutlet weak var tapotwo: UIButton!
    @IBOutlet weak var tapthree: UIButton!
    @IBOutlet weak var tapfour: UIButton!
    @IBOutlet weak var tapfive: UIButton!
    @IBOutlet weak var tapsix: UIButton!
    @IBOutlet weak var tapseven: UIButton!

    @IBAction func tapAudience(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CreateMediaToCreateGroup", sender: self)
    }
    @IBAction func tapObjective(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CreateMediaToCreateCampaign", sender: self)
    }
    @IBAction func tapRemove(_ sender: Any) {
        
        self.tapaddmedia.alpha = 1
        self.tapaddmedia.setBackgroundImage(UIImage(named: "GreyRectangle"), for: .normal)
        self.tapaddmedia.setTitle("Add Media", for: .normal)
        self.tapremove.alpha = 0
        self.selectedimageview.alpha = 0
        
        if uploadedimages[counter] != nil {
            
            uploadedimages.remove(at: counter)
        
//            uploadedimages.insert(UIImage(named: "GrayRectangle")!, at: counter)
        
//            uploadedimages[counter] = UIImage(named: "GrayRectangle")!
            
        } else {
            
            
        }
        
        
    }
    @IBAction func tapAddContent(_ sender: Any) {
    
        showloading()
        storedatalocally()
        taplaunch.isUserInteractionEnabled = true
    }
    
    @IBAction func tapAddMedia(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var imagePicker = UIImagePickerController()

    @IBAction func tapLaunch(_ sender: Any) {
        
        showloading()
        
        if pressedimages.count != 0 || pressedtext.count != 0 {
        
        let campaignrandomid = NSUUID().uuidString

        let grouprandomid = NSUUID().uuidString
   
    ref?.child("Campaigns").child(uid).child(campaignrandomid).updateChildValues(["Text" : 0])
        
        ref?.child("CampaignData").child(campaignrandomid).updateChildValues(["Cost" : "\(pressedcost)", "No" : "-", "Yes" : "-", "Total" : "-", "TotalRequest" : pressedresponses, "Title" : objectivepressed])
        
    ref?.child("Groups").child(campaignrandomid).child(grouprandomid).updateChildValues(["Text" : "0"])
        
    ref?.child("GroupData").child(grouprandomid).updateChildValues(["MinAge" : pressedminage, "MaxAge" : pressedmaxage, "Gender" : pressedgender, "Cost" : "\(pressedcost)", "Title" : "\(pressedgender) \(pressedminage) - \(pressedmaxage)", "No" : "-", "Yes" : "-", "Total" : "-"])
        
        var i = Int()
        
        var delimiter = "$"
        var token = pressedcost.components(separatedBy: delimiter)
            
            convertimagestolinks { () -> () in
                
                var contentcost = Double(token[1])! / Double(pressedimages.count)
                var contentviews = Double(pressedresponses)! / Double(pressedimages.count)
                
                let price = contentcost as NSNumber
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                // formatter.locale = NSLocale.currentLocale() // This is the default
                // In Swift 4, this ^ has been renamed to simply NSLocale.current
                formatter.string(from: price) // "$123.44"
                
                var currencycontentcost = formatter.string(from: price)!
                
                var stringtotalcost = formatter.string(from: price)
                
                while i < pressedimages.count {
                    
                    let newid = NSUUID().uuidString
                    
                    ref?.child("Content").child(grouprandomid).child(newid).updateChildValues(["Text" : "0"])
                    
                    
                    ref?.child("ContentData").child(newid).updateChildValues(["Image" : pressedimages[i] , "Title" : pressedtext[i], "Yes" : "-", "No" : "-", "Type" : "True", "Total" : "\(Int(contentviews))", "Cost" : "\(currencycontentcost)"])
                    
                    i += 1
                    
                }
                
                comingfromlaunch = true

                self.performSegue(withIdentifier: "LaunchToPayment", sender: self)
                
                self.hideloading()

            }
        


        
            
        }
        
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
    
    @IBAction func tap1(_ sender: Any) {
        
        counter = 0
        hideaddmedia()
        let imageFromButton : UIImage = tapone.backgroundImage(for: UIControlState.normal)!
        
        if imageFromButton == grey {
            
            showaddmedia()
            
        } else {
            
            selectedimageview.alpha = 1
            selectedimageview.image = imageFromButton
            
        }
        
        textField.text = pressedtext[0]
        
    }
    @IBAction func tap2(_ sender: Any) {
        
        counter = 1
        hideaddmedia()
        let imageFromButton : UIImage = tapotwo.backgroundImage(for: UIControlState.normal)!
        
        if imageFromButton == grey {
            
            showaddmedia()
            
        } else {
            
            selectedimageview.alpha = 1
            selectedimageview.image = imageFromButton
            
        }
        
        textField.text = pressedtext[1]
        
    }
    @IBAction func tap3(_ sender: Any) {
        
        counter = 2
        hideaddmedia()
        let imageFromButton : UIImage = tapthree.backgroundImage(for: UIControlState.normal)!
        
        if imageFromButton == grey {
            
            showaddmedia()
            
        } else {
            
            selectedimageview.alpha = 1
            selectedimageview.image = imageFromButton
            
        }
        
        textField.text = pressedtext[2]
    }
    @IBAction func tap4(_ sender: Any) {
        
        counter = 3
        hideaddmedia()
        let imageFromButton : UIImage = tapfour.backgroundImage(for: UIControlState.normal)!
        
        if imageFromButton == grey {
            
            showaddmedia()
            
        } else {
            
            selectedimageview.alpha = 1
            selectedimageview.image = imageFromButton
            
        }
        
        textField.text = pressedtext[3]
    }
    @IBAction func tap5(_ sender: Any) {
        counter = 4
        hideaddmedia()
        let imageFromButton : UIImage = tapfive.backgroundImage(for: UIControlState.normal)!
        
        if imageFromButton == grey {
            
            showaddmedia()
            
        } else {
            
            selectedimageview.alpha = 1
            selectedimageview.image = imageFromButton
            
        }
        
        textField.text = pressedtext[4]
    }
    @IBAction func tap6(_ sender: Any) {
        
        counter = 5
        hideaddmedia()
        let imageFromButton : UIImage = tapsix.backgroundImage(for: UIControlState.normal)!
        
        if imageFromButton == grey {
            
            showaddmedia()
            
        } else {
            
            selectedimageview.alpha = 1
            selectedimageview.image = imageFromButton
            
        }
        
        textField.text = pressedtext[5]
    }
    @IBAction func tap7(_ sender: Any) {
        counter = 6
        hideaddmedia()
        let imageFromButton : UIImage = tapseven.backgroundImage(for: UIControlState.normal)!
        
        if imageFromButton == grey {
            
            showaddmedia()
            
        } else {
            
            selectedimageview.alpha = 1
            selectedimageview.image = imageFromButton
            
        }
        
        textField.text = pressedtext[6]
    }
    
    func storeandreplacemedia() {
        
        
        if uploadedphoto != nil {
            
            if counter < uploadedimages.count {
                
                uploadedimages[counter] = uploadedphoto
                
            } else {
                
                uploadedimages.append(uploadedphoto)
            }
            
            
        } else {
            
            uploadedimages.append(UIImage(named: "GrayRectangle")!)
        }
        
        if textField.text != "" {
            
            if counter < pressedtext.count {
                
                pressedtext[counter] = textField.text!
                
            } else {
                
                pressedtext.append(textField.text!)
            }
            
        } else {
            
            pressedtext.append("")
            
        }
    }
    
    var uploadedphoto = UIImage()
    var uploadedtexts = String()
    
    func storedatalocally() {
        
        if selectedimageview.alpha == 1 {
            
            uploadedphoto = selectedimage
 
            self.storeandreplacemedia()
                    
            self.showphoto()
                    
                    
            self.counter += 1
                    
            self.hideloading()
            
        } else {
            
            print("No fucking photo")
            
            uploadedphoto = tapaddmedia.backgroundImage(for: .normal)!
            
            self.storeandreplacemedia()
            
            self.showphoto()
            
            self.counter += 1
            
            hideloading()
            
        }
    }
    
    
    func convertimagestolinks(completed: @escaping (() -> ()) ) {
        
        var functioncounter = 0
        var photocounter = 0
        
        for each in uploadedimages {
        
        photocounter += 1

        let storage = Storage.storage()
        let storageRef = storage.reference()
        var logoimagedata = Data()
        let currentUser = Auth.auth().currentUser
        
            
            logoimagedata = UIImageJPEGRepresentation(each, 0.8)!
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/jpg"
            
            let filePath = "\(uid)\(each)"
            
            storageRef.child(filePath).putData(logoimagedata, metadata: metaData){(metaData,error) in
                
                if let error = error {
                    
                    print(error.localizedDescription)
                    
                    return
                    
                } else {
                    
                    // store download url
                    let logodownloadURL = metaData!.downloadURL()!.absoluteString
                    
                    let currentUser = Auth.auth().currentUser
                    
                    var uid = String()
                    
                    uid = currentUser!.uid
                    
                    ref = Database.database().reference()
                    
                    self.stringimageurl = logodownloadURL
                    
                    
                    pressedimages.append(self.stringimageurl)
                    
                    functioncounter += 1
                    
                    if functioncounter == uploadedimages.count {
                        
                        completed()
                    }
                }
                
            }

        }
    }
    
    func hideaddmedia() {
        
        tapaddmedia.alpha = 0
        tapremove.alpha = 1
        self.selectedimageview.alpha = 1
    }
    
    func showaddmedia() {
        
        self.textField.text = ""
        self.textField.placeholder = "Enter Text"
        self.tapaddmedia.alpha = 1
        self.tapaddmedia.setBackgroundImage(UIImage(named: "GreyRectangle"), for: .normal)
        self.tapaddmedia.setTitle("Add Media", for: .normal)
        self.tapremove.alpha = 0
        self.selectedimageview.alpha = 0
    }
    
    let grey = UIImage(named: "GreyRectangle")

    func showphoto() {
        
        if counter == 0 {
            
            tapone.alpha = 1
            tapone.setTitle("", for: .normal)
            if selectedimageview.alpha == 0 {
                
                tapone.setImage(UIImage(named: "GreyRectangle"), for: .normal)
                
            } else {
                
                let imagenow = selectedimageview.image
                tapone.setBackgroundImage(imagenow, for: .normal)

            }
            
            showaddmedia()
        }
        
        if counter == 1 {
            
            tapotwo.alpha = 1
            tapotwo.setTitle("", for: .normal)

            if selectedimageview.alpha == 0 {
                
                tapotwo.setBackgroundImage(grey, for: .normal)
                
            } else {
                
                let imagenow = selectedimageview.image
                tapotwo.setBackgroundImage(imagenow, for: .normal)
                
            }
            
            showaddmedia()
            
        }
        
        if counter == 2 {
            
            tapthree.alpha = 1
            tapthree.setTitle("", for: .normal)
            
            if selectedimageview.alpha == 0 {
                
                tapthree.setBackgroundImage(grey, for: .normal)
                
            } else {
                
                let imagenow = selectedimageview.image
                tapthree.setBackgroundImage(imagenow, for: .normal)
                
            }
            
            showaddmedia()
            
        }
        
        if counter == 3 {
            
            tapfour.alpha = 1
            tapfour.setTitle("", for: .normal)
            
            if selectedimageview.alpha == 0 {
                
                tapfour.setBackgroundImage(grey, for: .normal)
                
            } else {
                
                let imagenow = selectedimageview.image
                tapfour.setBackgroundImage(imagenow, for: .normal)
                
            }
            
            showaddmedia()
            
        }
        
        if counter == 4 {
            
            tapfive.alpha = 1
            tapfive.setTitle("", for: .normal)
            
            if selectedimageview.alpha == 0 {
                
                tapfive.setBackgroundImage(grey, for: .normal)
                
            } else {
                
                let imagenow = selectedimageview.image
                tapfive.setBackgroundImage(imagenow, for: .normal)
                
            }
            
            showaddmedia()
            
        }
        
        if counter == 5 {
            
            tapsix.alpha = 1
            tapsix.setTitle("", for: .normal)
            
            if selectedimageview.alpha == 0 {
                
                tapsix.setBackgroundImage(grey, for: .normal)
                
            } else {
                
                let imagenow = selectedimageview.image
                tapsix.setBackgroundImage(imagenow, for: .normal)
                
            }
            
            showaddmedia()
            
        }
        
        if counter == 6 {
            
            tapseven.alpha = 1
            tapseven.setTitle("", for: .normal)
            
            if selectedimageview.alpha == 0 {
                
                tapseven.setBackgroundImage(grey, for: .normal)
                
            } else {
                
                let imagenow = selectedimageview.image
                tapseven.setBackgroundImage(imagenow, for: .normal)
                
            }
            
            showaddmedia()
            
        }
        
        taplaunch.setBackgroundImage(UIImage(named: "BlueRectangle"), for: .normal)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        textField.delegate = self
        tapremove.alpha = 0
        
        hideloading()
        
        selectedimageview.alpha = 0
        counter = 0
        pressedimages.removeAll()
        taplaunch.isUserInteractionEnabled = false
        pressedtext.removeAll()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    var selectedimage = UIImage()

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedimage = pickedImage
            selectedimageview.image = selectedimage

            hideaddmedia()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}


