//
//  MonitorActivity.swift
//  AnimatedScrollView
//
//  Created by Rupesh Pandey on 9/5/16.
//  Copyright © 2016 CreativeGray. All rights reserved.
//

import UIKit

class MonitorActivityView: UIView {

    @IBOutlet weak var horizontalPosition: NSLayoutConstraint!
    @IBOutlet weak var currentLocView: UIView!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var stopWatch: UIImageView!
    @IBOutlet weak var pathView: UIView!
    @IBOutlet weak var selectedUser: UIView!
    
    var shapeLayer : CAShapeLayer?
    var shapeLayer1 : CAShapeLayer?
    
    var position4 : CGFloat {
        return self.pathView.frame.origin.x + self.selectedUser.frame.origin.x
    }

    
    static func CustomView() -> MonitorActivityView {
        
        return (Bundle.main().loadNibNamed("MonitorActivity", owner: self, options: nil) .last as? MonitorActivityView)!
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // set the horizontal position off the screen; animated later
        self.horizontalPosition.constant = -176.0
        self.currentLocView.layer.borderColor = UIColor.white().cgColor
        self.currentLocView.layer.borderWidth  = 1.0
        
        self.mapPin.image = UIImage(named: "map_pin")?.withRenderingMode(.alwaysTemplate)
        self.stopWatch.image = UIImage(named: "stop_watch")?.withRenderingMode(.alwaysTemplate)
        
        // get the layer to stroke the black path
        self.shapeLayer = self.getPathLayer()
        
        // scale the shape layer to half the size to fit path view
        self.shapeLayer?.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        
        // add it to the pathView to be drawn
        self.pathView.layer.addSublayer(self.shapeLayer!)
        
        // get the layer to stroke the white path
        self.shapeLayer1 = self.getPathLayer1()
        
        // scale the shape layer to half the size
        self.shapeLayer1?.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        
        // add it to the pathView to be drawn
        self.pathView.layer.addSublayer(self.shapeLayer1!)
    }
    

    func animateCurrentLocView(percentage: CGFloat) {
        
        switch percentage {
            case 0.50:
                self.horizontalPosition.constant = -176.0
            case 0.75:
                self.horizontalPosition.constant = 82.0
            default:
                break
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                            self.layoutIfNeeded() // needed to animate the horizontal constraint
                        },
                       completion: nil)
    }
    

    func animatePath(percentage: CGFloat) {
    
        let minScale = 0.58
        let maxScale = 0.75
        let scalingFactor = maxScale - minScale
        let actualScale = (Double(percentage) - minScale) / scalingFactor
    
        // animates the black and white path layers.
        self.shapeLayer?.strokeEnd = fabs(CGFloat(actualScale))
        self.shapeLayer1?.strokeEnd = fabs(CGFloat(actualScale))
    }
    
    
    func getStrokePath() -> CGPath {
        
        let path = UIBezierPath()
    
        path.move(to: CGPoint(x: 160,y: 25))
        path.addCurve(to:CGPoint(x: 300, y: 120), controlPoint1: CGPoint(x: 320, y: 0) , controlPoint2: CGPoint(x: 300, y: 80))
        path.addCurve(to:CGPoint(x: 80, y: 380), controlPoint1: CGPoint(x: 300, y: 200) , controlPoint2: CGPoint(x: 200, y: 480))
        path.addCurve(to:CGPoint(x: 140, y: 300), controlPoint1: CGPoint(x: 0, y: 300) , controlPoint2: CGPoint(x: 200, y: 220))
        path.addCurve(to:CGPoint(x: 210, y: 200), controlPoint1: CGPoint(x: 30, y: 420) , controlPoint2: CGPoint(x: 280, y: 300))
        path.addCurve(to:CGPoint(x: 70, y: 110), controlPoint1: CGPoint(x: 110, y: 80) , controlPoint2: CGPoint(x: 110, y: 80))
        path.addCurve(to:CGPoint(x: 160, y: 25), controlPoint1: CGPoint(x: 0, y: 160) , controlPoint2: CGPoint(x: 0, y: 40))
        path.stroke()
        
        return path.cgPath
    }
    
    
    func getPathLayer() -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.lightGray().cgColor
        shapeLayer.path = self.getStrokePath()
        shapeLayer.strokeColor = UIColor.black().cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.green().cgColor
        
        return shapeLayer
    }
    

    func getPathLayer1() -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.lightGray().cgColor
        shapeLayer.path = self.getStrokePath()
        shapeLayer.strokeColor = UIColor.white().cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = nil
        
        return shapeLayer
    }
}
