//
//  PermissionsViewController.swift
//  RunWithMe
//
//  Created by Rupesh Pandey on 9/23/16.
//  Copyright © 2016 Creative Gray Inc. All rights reserved.
//

import UIKit
import Alamofire
import IoniconsSwift
import UserNotifications
import UserNotificationsUI
import PermissionScope

class PermissionsViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    
    let pscope = PermissionScope()
    
    var signUpData : [String : String]?
    
    var allowLocations : Bool = false {
        didSet {
            print("Location access granted")
            self.toggleFinishButton()
        }
    }
    
    
    var allowNotifs = false {
        didSet {
            self.toggleFinishButton()
        }
    }
    
    var allowMotionDetect = false {
        didSet {
            self.toggleFinishButton()
        }
    }
    
    
    @IBOutlet weak var locationCheckmark: UIImageView!
    @IBOutlet weak var notifsCheckmark: UIImageView!
    @IBOutlet weak var motionCheckmark: UIImageView!
    var alertView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Location & Alerts"
        
        //configure the views as buttons
        for view in self.stackView.arrangedSubviews {
            view.layer.cornerRadius = 4.0
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1.0
            view.backgroundColor = .clear
            
            view.addMotionEffect(CenterMotionEffect.effectWithMagnitude(magnitude: 20))
        }
        
        // setup checkmark buttons
        let checkImage = Ionicons.iosCheckmark.image(40.0, color: .orange)
        self.locationCheckmark.image = checkImage
        self.notifsCheckmark.image = checkImage
        self.motionCheckmark.image = checkImage
        
        self.doneButton.addMotionEffect(CenterMotionEffect.effectWithMagnitude(magnitude: 20))
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    

    @IBAction func tapLocationAccess(_ sender: AnyObject) {
        if self.allowLocations == false {
            self.locationCheckmark.alpha = 1.0
            self.allowLocations = true
            
            // request location access
            pscope.requestLocationInUse()
            pscope.requestLocationAlways()
            
        } else {
            self.locationCheckmark.alpha = 0.2
            self.allowLocations = false
        }
    }
    
    
    @IBAction func tapSendNotifs(_ sender: AnyObject) {
        if self.allowNotifs == false {
            self.notifsCheckmark.alpha = 1.0
            self.allowNotifs = true
            
                if PermissionScope().statusNotifications() == .authorized {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    pscope.requestNotifications()
                }
            
        } else {
            self.notifsCheckmark.alpha = 0.2
            self.allowNotifs = false
        }
    }
    
    
    @IBAction func tapDetectMotion(_ sender: AnyObject) {
        if self.allowMotionDetect == false {
            self.motionCheckmark.alpha = 1.0
            self.allowMotionDetect = true
            
            // request motion detection
            pscope.requestMotion()
        } else {
            self.motionCheckmark.alpha = 0.2
            self.allowMotionDetect = false
        }
    }
    
    
    func toggleFinishButton() {
        if self.allowLocations && self.allowNotifs && self.allowMotionDetect {
            self.doneButton.isEnabled = true
        } else {
            self.doneButton.isEnabled = false
        }
    }
    
    
    func finishSignupWith(data: [String : String]) {
        self.signUpData = data
    }
    
    
    @IBAction func finishSignUp(_ sender: AnyObject) {
        
        print("Sign up data: \(self.signUpData)")
        
        let spinner = SpinnerAnimView(frame: self.view.bounds, message: "")
        
        self.view.addSubview(spinner)
        self.view.bringSubview(toFront: spinner)
        
        if self.signUpData?["token"] != nil {
            
            let params = ["facebook_auth" : self.signUpData!]
            
            Alamofire.request(Router.signupUsingFacebook(params: params)).validate().responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    spinner.removeFromSuperview()
                    
                    if let dictionary = data as? [String: Any] {
                        switch dictionary["statuscode"] as! Int {
                        case 0: // existing user
                            self.showAlertView()
                        case 1: // new user
                            let defaults = UserDefaults.standard
                            defaults.set(dictionary["id"], forKey: "uid")
                            defaults.set(dictionary["name"], forKey: "name")
                            defaults.set(dictionary["auth_token"], forKey: "auth_token")
                            
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        default:
                            break
                        }
                    }
                case .failure(let error):
                    spinner.removeFromSuperview()
                    print(error)
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Signup failed: \(json)!")
                    }
                }
            })
        } else {
            
            // add the confirmation password
            self.signUpData?["confirmation_password"] = self.signUpData!["password"]
            
            // make a user with with user as key
            let params = ["user": self.signUpData!]
            
            Alamofire.request(Router.signupUser(params: params)).validate()
                .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    if let dictionary = data as? [String:Any] {
                        
                        let defaults = UserDefaults.standard
                        defaults.set(dictionary["id"], forKey: "uid")
                        defaults.set(dictionary["name"], forKey: "name")
                        defaults.set(dictionary["auth_token"], forKey: "auth_token")

                        spinner.removeFromSuperview()
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                case .failure(let error):
                    print(error)
                    if let data = response.data {
                        spinner.removeFromSuperview()
                        self.showAlertView()
                        
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Signup failed: \(json)!")
                    }
                }
            })
        }
    }
    
    
    func showAlertView() {
        
        // initialize an alert view
        let alertView = RWMAlert.init(frame: self.view.frame,
                                      message: "User already exists!",
                                      image: Ionicons.iosPersonOutline.image(64.0, color: .orange)) {
                                   
                                        // closure to call when the view is dissmissed
                                        
                                        // make the nav bar visisble again
                                        self.navigationController?.isNavigationBarHidden = false
                                        
                                        // pop to sign up view
                                        for controller in self.navigationController!.viewControllers as Array {
                                            if controller is JoinNowViewController {
                                                _ = self.navigationController?.popToViewController(controller as UIViewController, animated: false)
                                                break
                                            }
                                        }
        }
        
        // hide the nav bar for alert view
        self.navigationController?.isNavigationBarHidden = true
        
        // add the alert view to view hierarchy
        self.view.addSubview(alertView)
        
        // animate and show the alert view
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
