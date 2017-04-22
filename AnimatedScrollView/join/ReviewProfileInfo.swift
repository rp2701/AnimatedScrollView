//
//  ReviewInfoViewController.swift
//  RunWithMe
//
//  Created by Rupesh Pandey on 9/23/16.
//  Copyright © 2016 Creative Gray Inc. All rights reserved.
//

import Foundation
import UIKit

class ReviewProfileInfo: UIViewController, UITextFieldDelegate {
    
    func personalData(_ personalData: [String : String]) {
        self.personalData = personalData
    }
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imgBgview: UIView!
    
    @IBOutlet weak var separatorView: UIView!
   
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!

    var tfTags = [1, 2]
    
    var firstName: String?
    var lastName: String?
    
    var personalData: [String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Review Info"
        // set no title for back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        var str = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName:UIColor.lightText])
        self.firstNameTextField.attributedPlaceholder = str
        
        str = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName:UIColor.lightText])
        self.lastNameTextField.attributedPlaceholder = str
        
        self.profilePic.image = UIImage(named: "user_exists")?.withRenderingMode(.alwaysTemplate)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        if let data = personalData {
            self.firstName = data["first_name"]
            self.firstNameTextField.text = self.firstName ?? nil
            
            self.lastName = data["last_name"]
            self.lastNameTextField.text = self.lastName ?? nil
        }
        
//        if (self.firstNameTextField.text?.isEmpty)! {
//            self.firstNameTextField.becomeFirstResponder()
//        } else {
//            self.lastNameTextField.becomeFirstResponder()
//        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let newImage = UIImage(named: "user_exists")?.withRenderingMode(.alwaysTemplate)
        _ = (newImage?.size)!.applying(CGAffineTransform(scaleX: 0, y: 0))
        
        let origPosition = self.separatorView.layer.position

        UIView.animate(withDuration: 0.5, animations: {
            self.profilePic?.image = newImage
            self.profilePic?.tintColor = UIColor.orange
            (newImage?.size)!.applying(CGAffineTransform(scaleX: 1.0, y: 1.0))

            self.separatorView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
            self.separatorView.layer.position = origPosition
            self.separatorView.alpha = 1.0
        })
   
        if (self.firstNameTextField.text?.isEmpty)! {
            self.firstNameTextField.becomeFirstResponder()
        } else {
            self.lastNameTextField.becomeFirstResponder()
        }

    }
    
    
 
    @IBAction func presentNextScene(_ sender: AnyObject) {
        
        print ("Full Name: \(self.firstName) \(self.lastName)")
        if (firstName ?? "").isEmpty {
            print("First name not filled")
            self.animate(self.firstNameTextField)
            return
        } else if  (lastName ?? "").isEmpty {
            print("Last name not filled ")
            self.animate(self.lastNameTextField)
            return
        }

        let permissionsVC = PermissionsViewController()
        self.personalData?["name"] = "\(self.firstName!) \(self.lastName!)"
        
        permissionsVC.finishSignupWith(data: self.personalData!)
        self.navigationController?.pushViewController(permissionsVC, animated: true)
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
                    textField.becomeFirstResponder()
                })
        })
    }
  
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.tintColor = .orange // needed to make the cursor visible
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 1:
            self.firstName = textField.text!
        case 2:
            self.lastName = textField.text!
        default:
            break
        }
        return true
    }
    
    
    @IBAction func editingChanged(_ sender: UITextField) {
    
        print("FirstName: \(sender.text)")
        switch sender.tag {
        case 1:
            self.firstName = sender.text!
        case 2:
            self.lastName = sender.text
        default:
            break
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
////        guard (textField.text?.isEmpty)! else {
////            return
////        }
////        
//        switch textField.tag {
//        case 1:
////            self.firstName = textField.text!
//            if self.firstName!.isEmpty {
//                self.tfTags.remove(at: 0)
//            }
//        case 2:
////            self.lastName = textField.text!
//            if self.lastName!.isEmpty {
//                self.tfTags.remove(at: 1)
//            }
//        default:
//            break
//        }
//    }
    
    
}


extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}
