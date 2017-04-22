//
//  JoinNowViewController.swift
//  AnimatedScrollView
//
//  Created by Rupesh Pandey on 9/19/16.
//  Copyright © 2016 CreativeGray. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit

class JoinNowViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var fbButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var envelopeLeading: NSLayoutConstraint!
    @IBOutlet weak var passwordLeading: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activeTextField: UITextField?
    
    @IBOutlet weak var envelopeImgView: UIImageView!
    
    @IBOutlet weak var passwordImgView: UIImageView!
    @IBOutlet weak var validEmailView: UIImageView!
    @IBOutlet weak var validPasswordView: UIImageView!
    
    @IBOutlet weak var separatorView: UIView!
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    // user data
    var emailAddress : String?
    var password : String?
    
    @IBOutlet weak var passwordCount: UILabel!
    
    var passwordCounter = 0
   
    
    let padlockOpenImg = UIImage(named: "padlock_open_2")?.withRenderingMode(.alwaysTemplate)
    let padlockClosedImg = UIImage(named: "padlock_closed_2")?.withRenderingMode(.alwaysTemplate)
    
    
    var validEmailEntered = false {
        didSet {
            self.toggleNextButton()
        }
    }
    
    var validPasswordEntered = false {
        didSet {
            self.toggleNextButton()
        }
    }
    
    var attributedEmail : NSAttributedString {
        return NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIColor.lightText])
    }
    
    var attibutedPassword : NSAttributedString {
        return NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.lightText])
    }
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
      
        
        // Do any additional setup after loading the view.
        self.title = "Join Now"
        
        let navBar = self.navigationController?.navigationBar
        navBar?.isTranslucent = true
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.isTranslucent = true
        navBar?.shadowImage = UIImage()
        
        // set no title for back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.fbButton.addMotionEffect(CenterMotionEffect.effectWithMagnitude(magnitude: 20))
    
        let image = UIImage(named: "facebook")?.withRenderingMode(.alwaysTemplate)
        fbButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        fbButton.setImage(image, for: .normal)
        fbButton.tintColor = .white
        
        self.envelopeImgView.image = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
        self.passwordImgView.image = self.padlockOpenImg
        
        self.emailTextField.attributedPlaceholder = attributedEmail
        self.passwordTextField.attributedPlaceholder = attibutedPassword
        
        self.validEmailView.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
        self.validPasswordView.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
        
    }

    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let origPosition = self.separatorView.layer.position
        
        
        UIView.animate(withDuration: 0.5, animations: {
       
            
            self.separatorView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
            self.separatorView.layer.position = origPosition
            self.separatorView.alpha = 1.0
        })
        
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.tintColor = .orange // needed to make the cursor visible
        
        /// animate the respective imageview and textfields when it becomes first responder
        switch textField.tag {
        case 1:
            self.envelopeLeading.constant = 20
            self.animate(textField, 30.0)
            textField.placeholder = nil
        case 2:
            self.passwordLeading.constant = 20
            self.animate(textField, 30.0)
            textField.placeholder = nil
        default:
            break
        }
        return true
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2 {
            
            //calculate the current charate count
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            self.passwordCounter = 8 - newLength
        
            // show the password count view
            if self.passwordCounter > 0 {
                self.passwordCount.alpha = 1
                self.validPasswordView.alpha = 0
                self.validPasswordEntered = false
                self.passwordImgView.image = self.padlockOpenImg
            }
            
            
            // if count is zero hide the count view and show the passwowd valid view and the next button.
            if self.passwordCounter == 0 {
                self.passwordCount.alpha = 0
                self.validPasswordView.alpha = 1
                self.validPasswordEntered = true
                
                self.passwordImgView.image = self.padlockClosedImg
            }
            
            self.passwordCount.text = String(passwordCounter)
        }
        return true
    }

    
    @IBAction func editingChanged(_ sender: AnyObject) {
        
        let tf = sender as! UITextField
        
        switch tf.tag {
        case 1:
            if (tf.text?.isValidEmail())! {
                print("Valid Email")
                self.emailAddress = tf.text
                self.validEmailEntered = true
                self.validEmailView.alpha = 1
                
            } else {
                print("InValid Email")
                self.validEmailEntered = false
                self.validEmailView.alpha = 0
            }
        case 2:
            self.password = tf.text
        default:
            break
        }
    }
    

    func toggleNextButton() {
        if self.validEmailEntered && self.validPasswordEntered {
            self.emailButton.isEnabled = true
            self.emailButton.setTitleColor(.white, for: .normal)
            self.emailButton.borderColor = .white

        } else {
            self.emailButton.isEnabled = false
            self.emailButton.setTitleColor(.lightGray, for: .normal)
            self.emailButton.borderColor = .lightGray
        }
    }
    
    
    // Animate the textfields for incorrect inputs but let the user continue
    // between textfields.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            if (validEmailEntered == false ) {
                self.animate(self.emailTextField)
            }
        case 2:
            if (validPasswordEntered == false) {
                self.animate(self.passwordTextField)
            }
        default:
            break
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // textfield empty - show the placeholder
        if  textField.text!.isEmpty  {
            switch textField.tag {
            case 1:
                textField.attributedPlaceholder = attributedEmail
                self.envelopeLeading.constant = -50.0
                self.animate(textField, 0)
                
            case 2:
                
                textField.attributedPlaceholder = attibutedPassword
                self.passwordLeading.constant = -50.0
                self.animate(textField, 0)
                
            default:
                break
            }
        } else {
            // animate textfields for invalid inputs
            switch textField.tag {
            case 1:
                if (validEmailEntered == false ) {
                    self.animate(self.emailTextField)
                }
            case 2:
                if (validPasswordEntered == false) {
                    self.animate(self.passwordTextField)
                }
            default:
                break
            }
        }
        
    }
    
    func animate(_ tf: UITextField, _ scale: CGFloat)  {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                            // animate the textfield sublayer so that it is offset by scale
                            tf.layer.sublayerTransform = CATransform3DMakeTranslation(scale, 0, 0);
                        
                            // needed to animate the horizontal constraint for imageView
                            self.view.layoutIfNeeded()
                        },
                       completion: nil)
    }
    
    
    
    func animate(_ textField: UITextField) {
        
        let numShakes = 4
        let t1 = CGAffineTransform(translationX: 4, y: 0)
        let t2 = CGAffineTransform(translationX: -4, y: 0)
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            
            for idx in 0..<numShakes {
                let progress = Double(idx)/Double(numShakes)
                UIView.addKeyframe(withRelativeStartTime: progress, relativeDuration: 1.0/progress, animations: {
                    
                    textField.transform = (idx % 2 == 0) ? t1: t2
                })
            }
        
            
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    textField.transform = CGAffineTransform(translationX: 0, y: 0)
        
                })
        })
    }
    
    
    @IBAction func presentNextScene(_ sender: AnyObject) {
        
        let reviewProfileVC = ReviewProfileInfo()
        reviewProfileVC.personalData([ "email" : self.emailAddress!, "password" : self.password! ])
        self.navigationController?.pushViewController(reviewProfileVC, animated: true)
    }
    
    
    @IBAction func connectWithFacebook(_ sender: AnyObject) {
        
        let login = FBSDKLoginManager()
        
        login.logIn(withReadPermissions: ["email", "public_profile"], from: self, handler: {
            (result, error) in
            if let err = error {
                print("FB Login failed")
                print(err.localizedDescription)
            }
            else if (result!.isCancelled) // if the user cancels in SafariController
            {
                // Logged out?
                print( "App Signup Cancelled in SafariViewController")
            }
            else {
                print("FB Email \(result?.grantedPermissions.contains("email"))")
                print("FB Email \(result?.grantedPermissions.contains("public_profile"))")
                
                if (result?.grantedPermissions.contains("email"))! && (result?.grantedPermissions.contains("public_profile"))! {
                    self.fetchUserDataFromFBGraph()
                }
            }
        })
    }
    
    
    func fetchUserDataFromFBGraph() {
        
        let graphRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields" : "id, email, first_name, last_name"])
        
        _ = graphRequest?.start(completionHandler: { (connection, result, error) in
            
            if (error != nil) {
                print("Graph error: \(error)")
            } else {
                
                var userData : [String : String]? = result as? [String : String]
                
                if userData != nil {
                    
                    print("Graph Result: \(userData!)")
                    userData!["token"] = FBSDKAccessToken.current().tokenString
                    userData!["provider"] = "facebook"
                    
                    let reviewInfoFromFacebookVC = ReviewInfoViewController()
                    reviewInfoFromFacebookVC.signUpData(userData!)
                    
                    // navigate to next scene
                    self.navigationController?.pushViewController(reviewInfoFromFacebookVC, animated: true)
                }
            }
        })
    }
}



// extension on String to validate email addresses.
extension String {
    // validate the email address provided
    func isValidEmail() -> Bool {
        //        let emailRegex = ".+@.+.[A-Za-z-]{2}[A-Za-z]*"
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}


// customizes the button in nib editor
extension UIButton{
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
            layer.borderWidth = 1
        }
    }
}
