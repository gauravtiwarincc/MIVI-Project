//
//  userDetailsViewController.swift
//  Sample Project
//
//  Created by Paresh Mittal on 06/05/18.
//  Copyright © 2018 Paresh Mittal. All rights reserved.
//

import UIKit

class userDetailsViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var contactNo: UILabel!
    @IBOutlet weak var creditLeft: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    var jsonData:NSDictionary?
    @IBOutlet weak var subscriptionExpiryLabel: UILabel!
    @IBOutlet weak var subscriptionsCreditLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    var subscriptionId:[String] = []
    var productID:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserPrimaryDetails()
        setCreditDetails()
        setSubscriptionDetails()
    }
    func setUserPrimaryDetails() {
        if let data = jsonData!["data"] as? [String:Any], let attributes = data["attributes"] as? [String:Any] {
            if let title = attributes["title"] as? String, let fName = attributes["first-name"] as? String, let lName = attributes["last-name"] as? String, let contact = attributes["contact-number"] as? String {
                name.text = "Welcome" + " " + title + " " + fName + " " + lName
                contactNo.text = "+" + contact
            }
        }
    }
    
    func setCreditDetails() {
        if let data = jsonData!["included"] as? NSArray, let details = data[0] as? [String:Any] {
            if let attributes = details["attributes"] as? [String:Any], let creditsLeft = attributes["credit"] as? Int, let creditExpiry = attributes["credit-expiry"] as? String {
                creditLeft.text = "Credits Left: " + "\(creditsLeft)"
                expiryDate.text = "Credits Expiry:" + creditExpiry
            }
            if let relationships = details["relationships"] as? [String:Any], let subscriptionData = relationships["subscriptions"] as? [String:Any], let mainData = subscriptionData["data"] as? [Dictionary<String, Any>] {
                for info in mainData {
                    if let id = info["id"] as? String {
                        subscriptionId.append(id)
                    }
                }
            }
        }
    }
    
    func setSubscriptionDetails() {
        if let data = jsonData!["included"] as? NSArray, let details = data[1] as? [String:Any] {
            if let attributes = details["attributes"] as? [String:Any], let dataBalance = attributes["included-data-balance"] as? Int, let creditExpiry = attributes["expiry-date"] as? String,let subId = details["id"] as? String {
                if subscriptionId.contains(subId) {
                subscriptionsCreditLabel.text = "Credits Included: " + "\(dataBalance)"
                subscriptionExpiryLabel.text = "Credits Expiry:" + creditExpiry
                } else {
                    subscriptionsCreditLabel.text = "Credits Included: " + "No Subscription"
                    subscriptionExpiryLabel.text = "Credits Expiry:" + "No Subscription"
                }
            }
            if let relationships = details["relationships"] as? [String:Any] {
                let productData = relationships["product"] as? [String:Any]
                let mainData = productData!["data"] as? [String:Any]
                productID.append((mainData!["id"] as? String)!)
            }
        }
        
        if let data = jsonData!["included"] as? NSArray, let details = data[2] as? [String:Any] {
            if let attributes = details["attributes"] as? [String:Any], let name = attributes["name"] as? String, let price = attributes["price"] as? Int,let prodId = details["id"] as? String {
                if productID.contains(prodId) {
                    productPriceLabel.text = "Product Price: " + "\(price)"
                    productNameLabel.text = "Product Name:" + name
                } else {
                    productPriceLabel.text = "Product Price: " + "No Product Attached"
                    productNameLabel.text = "Product Name:" + "No Product Attached"
                }
            }
        }
        
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
