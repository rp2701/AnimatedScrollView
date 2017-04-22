//
//  RWMAlert.swift
//  RunWithMe
//
//  Created by Rupesh Pandey on 10/3/16.
//  Copyright © 2016 Creative Gray Inc. All rights reserved.
//
import UIKit
import Foundation

class RWMAlert : UIView {
    
    typealias completion = (() -> Void)?
    var success: completion

    @IBOutlet var view: UIView!
    
    // Init with bounds size and an optional closure, which is equivalent to @escaping 
    // and allows passing in nil for closure.
    init(frame: CGRect, message:String?, image: UIImage?, _ closure: (() -> Void)? ) {

        // store closure for async execution
        self.success = closure
        
        super.init(frame: frame)        
    
        initFromNib(message, image)
    }

    
    func initFromNib(_ message:String?, _ image: UIImage?) {
        
        self.view = Bundle.main.loadNibNamed("RWMAlertView", owner: self, options: nil)! .first as! UIView!
        view?.frame = frame
        
        let alertLbl = view?.viewWithTag(10) as! UILabel
        alertLbl.text = message ?? "User has already been taken"
        alertLbl .sizeToFit()
        
        let imgView = view?.viewWithTag(11) as? UIImageView
        imgView?.image = image ?? UIImage(named: "user_exists")?.withRenderingMode(.alwaysTemplate)
        
        self.addSubview(view!)
        
        // transform size, will be animated when presented.
        self.transform = CGAffineTransform(scaleX: 0, y: 0)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    

    @IBAction func tapDetected(_ sender: AnyObject) {
        
        // remove self from view hierarchy
        self.removeFromSuperview()
        
        // execute the passed in closure
        self.success?()
    }
}
