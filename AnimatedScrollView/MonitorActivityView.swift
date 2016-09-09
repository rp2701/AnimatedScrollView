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
    var shapeLayer : CAShapeLayer?
    var shapeLayer1 : CAShapeLayer?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    static func CustomView() -> MonitorActivityView {
        
        return (Bundle.main().loadNibNamed("MonitorActivity", owner: self, options: nil) .last as? MonitorActivityView)!
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set the horizontal position off the screen; animated later
        self.horizontalPosition.constant = -196.0
        self.currentLocView.layer.borderColor = UIColor.white().cgColor
        self.currentLocView.layer.borderWidth  = 2.0
        
        self.mapPin.image = UIImage(named: "map_pin")?.withRenderingMode(.alwaysTemplate)
        self.stopWatch.image = UIImage(named: "stop_watch")?.withRenderingMode(.alwaysTemplate)
        
        
        let imageView = UIImageView(image: UIImage(named: "map"))
        imageView.frame = self.bounds
        imageView.frame.size.height = imageView.frame.size.height + 20
        
        imageView.contentMode = .scaleToFill
    
        
        imageView.blurImage()
        self.addSubview(imageView)
        self.sendSubview(toBack: imageView)
        
        // create and add the stroked path
        self.shapeLayer = self.getPathLayer()
        
        self.shapeLayer?.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        self.pathView.layer.addSublayer(self.shapeLayer!)
        
        self.shapeLayer1 = self.getPathLayer1()
        self.shapeLayer1?.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        
        self.pathView.layer.addSublayer(self.shapeLayer1!)
    }
    
    
    func animateCurrentLocView(percentage: CGFloat) {
        
        switch percentage {
            case 0.50:
                self.horizontalPosition.constant = -176.0
            case 0.75:
                self.horizontalPosition.constant = 76.0
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
    
        
        let minScale = 0.54
        let maxScale = 0.75
        
        let scalingFactor = maxScale - minScale
        
        let actualScale = (Double(percentage) - minScale) / scalingFactor
        
        // use a constant velocity
        let options = UIViewKeyframeAnimationOptions.calculationModeCubicPaced
        print("Actual scale: \(actualScale)")
        
        if actualScale <= 1.0 {
            UIView.animateKeyframes(withDuration: 0, delay: 0, options: options, animations: {
                
                // animate the stroke
                UIView.addKeyframe(withRelativeStartTime: actualScale, relativeDuration: 0, animations: {
                    self.shapeLayer?.strokeEnd = fabs(CGFloat(actualScale))
                    self.shapeLayer1?.strokeEnd = fabs(CGFloat(actualScale))
                })
                
                }, completion: nil)
        }
    }
    
    
    func getStrokePath() -> CGPath
    {
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
