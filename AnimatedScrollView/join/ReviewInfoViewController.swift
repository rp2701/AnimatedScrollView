//
//  ReviewInfoViewController.swift
//  RunWithMe
//
//  Created by Rupesh Pandey on 9/23/16.
//  Copyright © 2016 Creative Gray Inc. All rights reserved.
//

import UIKit

class ReviewInfoViewController: UIViewController, UITextFieldDelegate {
   
    

    @IBOutlet weak var nextButton: UIButton!
    
    var activeTextField: UITextField?
    
    @IBOutlet weak var passwordImgView: UIImageView!
    @IBOutlet weak var envelopeImgView: UIImageView!
    @IBOutlet weak var validEmailView: UIImageView!
    @IBOutlet weak var validPasswordView: UIImageView!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordCount: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var signUpData: [String:String]?
    
    let padlockOpenImg = UIImage(named: "padlock_open_2")?.withRenderingMode(.alwaysTemplate)
    let padlockClosedImg = UIImage(named: "padlock_closed_2")?.withRenderingMode(.alwaysTemplate)
    
    
    @IBOutlet weak var separatorView: UIView!
    
    var passwordCounter = 0
    
    var facebookEmail : String?
    var userPassword : String?
    
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
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Review Info"
        // set no title for back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.envelopeImgView.image = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
        self.passwordImgView.image = UIImage(named: "padlock_open_2")?.withRenderingMode(.alwaysTemplate)
        
        
        var str = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIColor.lightText])
        self.emailTextField.attributedPlaceholder = str
        
        str = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.lightText])
        self.passwordTextField.attributedPlaceholder = str
        
        

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let fbData = self.signUpData {
            self.emailTextField.text = fbData["email"]
            self.validEmailView.alpha = 1.0
            self.validEmailEntered = true
            
//            self.passwordTextField.becomeFirstResponder()
        } else {
//            self.emailTextField.becomeFirstResponder()
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        // animate the height and alpha of separator view
        let origPosition = self.separatorView.layer.position
        UIView.animate(withDuration: 0.5, animations: {
        
            self.separatorView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
            self.separatorView.layer.position = origPosition
            self.separatorView.alpha = 1.0
        })
        
//        if self.validEmailEntered {
        
            self.passwordTextField.becomeFirstResponder()
//        } else {
//            self.emailTextField.becomeFirstResponder()
//        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    func toggleNextButton() {
        if self.validEmailEntered && self.validPasswordEntered {
            self.nextButton.isEnabled = true
            self.nextButton.setTitleColor(.white, for: .normal)
            self.nextButton.borderColor = .white
            
        } else {
            self.nextButton.isEnabled = false
            self.nextButton.setTitleColor(.lightGray, for: .normal)
            self.nextButton.borderColor = .lightGray
        }
    }

    
    @IBAction func presentNextScene(_ sender: AnyObject) {
        let nextScene = ReviewProfileInfo()
        
        if let email = self.facebookEmail {
            self.signUpData?["email"] = email
        }
        self.signUpData?["password"] = self.userPassword!
        self.signUpData?["confirmation_password"] = self.userPassword!
        nextScene.personalData(self.signUpData!)
        
        self.navigationController?.pushViewController(nextScene, animated: true)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        textField.tintColor = .orange // needed to make the cursor visible
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
        if tf.tag == 1 {
            if (tf.text?.isValidEmail())! {
                self.facebookEmail = tf.text
                print("Valid Email")
                self.validEmailEntered = true
                self.validEmailView.alpha = 1
                
            } else {
                print("InValid Email")
                self.validEmailEntered = false
                self.validEmailView.alpha = 0
            }
        } else if tf.tag == 2 {
            self.userPassword = tf.text
        }
    }

    
    func signUpData(_ data: [String : String]) {
        self.signUpData = data
    }
    
}

protocol ReviewProfileData {
    func personalData(personalData: [String:String])
}
