//
//  StartActivity.swift
//  AnimatedScrollView
//
//  Created by Rupesh Pandey on 9/5/16.
//  Copyright © 2016 CreativeGray. All rights reserved.
//

import UIKit

class StartActivityView: UIView {
    
    @IBOutlet weak var clockImg: UIImageView!
    @IBOutlet weak var mapImg: UIImageView!
    @IBOutlet weak var outerView: UIView!
    
    static func CustomView() -> StartActivityView {
        
        return (Bundle.main.loadNibNamed("StartActivity", owner: self, options: nil)! .last as? StartActivityView)!
    }

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        clockImg.image = UIImage(named: "alarms")?.withRenderingMode(.alwaysTemplate)
        mapImg.image = UIImage(named:"map_location")?.withRenderingMode(.alwaysTemplate)

        // need this because it cannot be set as a runtime attrib on the nib
        self.outerView.layer.borderColor = UIColor.white.cgColor
    }
    
    
    func animateIcons(percentage: CGFloat) {
        
        let numShakes = 4
        let t1 = CGAffineTransform(translationX: 3, y: 0)
        let t2 = CGAffineTransform(translationX: -3, y: 0)
        
        if percentage == 0.5 {
            
            UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
                
                for idx in 0..<numShakes {
                    let progress = Double(idx)/Double(numShakes)
                    UIView.addKeyframe(withRelativeStartTime: progress, relativeDuration: 1.0/progress, animations: {
                        
                        self.clockImg.transform = (idx % 2 == 0) ? t1: t2
                    })
                }
                UIView.animate(withDuration: 0.5, animations: { 
                    self.mapImg.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                })
                
                }, completion: { _ in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.clockImg.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.mapImg.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
            })
        }
    }
}
