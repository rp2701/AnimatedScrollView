//
//  BarGraphView.swift
//  AnimatedScrollView
//
//  Created by Rupesh Pandey on 9/4/16.
//  Copyright © 2016 CreativeGray. All rights reserved.
//

import Foundation
import UIKit



public class BarGraphView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var pathView: UIView!
    
    var origRect: CGRect?
    var stackViewRect: CGRect?
    var fixedLayerPosition: Bool? = false
    var shapeLayer: CAShapeLayer?
    
    
    static func CustomView() -> BarGraphView {
        return (Bundle.main().loadNibNamed("BarGraphView", owner: self, options: nil) .last as? BarGraphView)!
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    
    override public func awakeFromNib() {

        super.awakeFromNib()
        
        self.activitiesLabel.layer.anchorPoint = CGPoint(x: 0.2, y: 0.8)
        
        self.activitiesLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        
        self.shapeLayer = self.getPathLayer()
        self.pathView.layer.addSublayer(self.shapeLayer!)
    }
    
    
    public func animateViews(percentage: CGFloat) {

        if self.fixedLayerPosition! == false {
            for uiView in stackView.arrangedSubviews {
                fixLayerPosition(bar: uiView)
            }
            fixedLayerPosition = true
        }
        
        let minScale = 0.78
        let maxScale = 1.0
        
        let scalingFactor = maxScale - minScale
        
        let actualScale = (Double(percentage) - minScale) / scalingFactor
        print("Actual scale: \(actualScale)")
        
        if actualScale <= 1.0 {
            // animate the bars
            for v in self.stackView.arrangedSubviews {
                v.transform = CGAffineTransform(scaleX: fabs(CGFloat(actualScale)), y: fabs(CGFloat(actualScale)))
            }
        
            // animate the path layer
            self.shapeLayer?.strokeEnd = CGFloat(actualScale)
        }
    }
    
    
    // fix the layer position to take accommodate anchorPoint change.accommodate
    // anchorPoint is set as a runtime attribute at design time in the IDE
    func fixLayerPosition(bar: UIView) {
        
        let x = bar.frame.origin.x
        let y = self.stackView.bounds.size.height
        
        bar.layer.position = CGPoint(x: x, y: y)
    }
    
    
    func getStrokePath() -> CGPath
    {
        let path = UIBezierPath()
        
//        path.move(to: CGPoint(x: 85,y: 360))
//        path.addCurve(to: CGPoint(x: 300, y: 360), controlPoint1: CGPoint(x: 140, y: 275), controlPoint2: CGPoint(x: 160, y: 450))
        
        
        path.move(to: CGPoint(x: 0,y: 100))
        path.addCurve(to: CGPoint(x: 210, y: 100), controlPoint1: CGPoint(x: 40, y: 0), controlPoint2: CGPoint(x: 120, y: 200))
        
        //draw the stroke
        path.stroke()
        
        return path.cgPath
    }

    
    func getPathLayer() -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.lightGray().cgColor
        shapeLayer.path = self.getStrokePath()
        shapeLayer.strokeColor = UIColor(hex: 0xffcc66).cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = nil
        
        return shapeLayer
    }
}


