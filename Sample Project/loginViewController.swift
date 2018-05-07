//
//  ViewController.swift
//  Sample Project
//
//  Created by Paresh Mittal on 06/05/18.
//  Copyright © 2018 Paresh Mittal. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    var jsonData:NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func onTapSignIn(_ sender: Any) {
        if let path = Bundle.main.path(forResource: "collection", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                if jsonResult != nil {
                    jsonData = jsonResult! as? NSDictionary
                    if let data = jsonResult!["data"] as? [String:Any], let attributes = data["attributes"] as? [String:Any] {
                        if let emailID = attributes["email-address"] as? String {
                            if emailID == emailIDTextField.text {
                                splashView.isHidden = false
                                emailIDTextField.resignFirstResponder()
                                Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(dismissAndPushView), userInfo: nil, repeats: false)
                            } else {
                                let alert = UIAlertController(title: "Alert", message: "Invalid EmailID", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            } catch {
                // handle error
            }
        }
    }
    
    @objc func dismissAndPushView() {
        self.splashView.isHidden = true
        let userDetailsVc = storyboard?.instantiateViewController(withIdentifier: "userDetails") as! userDetailsViewController
        if let data = self.jsonData {
        userDetailsVc.jsonData = data
        }
        self.navigationController?.pushViewController(userDetailsVc, animated: true)
    }
    
}

