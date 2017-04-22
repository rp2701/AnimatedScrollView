//
//  SpinnerAnimView.swift
//  RunWithMe
//
//  Created by Rupesh Pandey on 9/29/16.
//  Copyright © 2016 Creative Gray Inc. All rights reserved.
//

import UIKit

class SpinnerAnimView: UIView {

    @IBOutlet var view: UIView!
    
    init(frame: CGRect, message: String) {
        
        super.init(frame: frame)
        initFromNib()
    }
    
    
    func initFromNib() {
        
        self.view = Bundle.main.loadNibNamed("SpinnerAnimView", owner: self, options: nil)! .first as! UIView!
        view?.frame = frame
        self.addSubview(self.view)
        
        print("Bounds: \(self.bounds)")
        
        // Create CAShapeLayerS
        let bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        let rectShape = CAShapeLayer()
        rectShape.bounds = bounds
        rectShape.position = (view?.center)!
        rectShape.cornerRadius = bounds.width / 2
        
        self.layer.addSublayer(rectShape)
        
        // create spinner view logic
        rectShape.path = UIBezierPath(ovalIn: rectShape.bounds).cgPath
        
        rectShape.lineWidth = 3.0
        rectShape.strokeColor = UIColor.orange.cgColor
        rectShape.fillColor = UIColor.clear.cgColor
        
        // 2
        rectShape.strokeStart = 0
        rectShape.strokeEnd = 0.7
        
        // 3
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.toValue = 0.7
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.toValue = 1.0
        
        // 4
        let group = CAAnimationGroup()
        group.animations = [start, end]
        group.duration = 1.5
        group.autoreverses = true
        group.repeatCount = HUGE // repeat forver
        rectShape.add(group, forKey: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
}
