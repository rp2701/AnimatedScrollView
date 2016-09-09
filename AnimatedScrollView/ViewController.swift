
//  ViewController.swift
//  AnimatedScrollView
//
//  Created by Rupesh Pandey on 8/27/16.
//  Copyright © 2016 CreativeGray. All rights reserved.
//

import UIKit


@available(iOS 10.0, *)
class ViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var xSize: NSLayoutConstraint!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var progressStackView: UIStackView!
    var panRight = false
    var panLeft = false
    
    var currentPage = 0
    
    // views that make up this scrollView's content
    
    var searchFriendsView: SearchFriendsView?
    var trackingView: MonitorActivityView?
    var barGraphView: BarGraphView?
    
    static var count = 0
    
    let color2 = 0x66e6ff
    let color1 = 0x6699ff
    let scrollViewCount = 5
    
    var square : UIView?
    
    var frame: CGRect = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for index in 0 ..< scrollViewCount {

            // calculates the frame for each subview to be inserted into scroll view
            frame.origin.x = self.scrollView.bounds.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            
            switch index {
                case 0:
                    let subView = UIView(frame: frame)
                    //self.addBlurEffect(to: subView)
                    let bgView = UIImageView(image: UIImage(named: "app-bg"))
                    bgView.frame = frame
                    subView.insertSubview(bgView, at: 0)
                    subView.backgroundColor = UIColor(hex: color1, 0.94) // slightly opaque than others
                    self.scrollView .addSubview(subView)
                case 1:
                    searchFriendsView = SearchFriendsView.CustomView()
                    
                    searchFriendsView?.frame = frame
                    
                    self.scrollView.addSubview(searchFriendsView!)
                case 2:
                    let startActivityView = StartActivityView.CustomView()
                    startActivityView.frame = frame
                    self.scrollView.addSubview(startActivityView)
                case 3:
                    trackingView = MonitorActivityView.CustomView()
                    trackingView?.frame = frame
                    self.scrollView.addSubview(trackingView!)
                case 4:
                    self.barGraphView = BarGraphView.CustomView()
                    self.barGraphView?.frame = frame
                    self.scrollView.addSubview(self.barGraphView!)
                default:
                    let subView = UIView(frame: frame)
                    self.scrollView .addSubview(subView)
            }
        }
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.bounds.size.width * CGFloat(scrollViewCount), height: 1.0)

        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
//        let widthConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: self.scrollView.contentSize.width)
        
//        self.xSize.constant = widthConstraint.constant
        
        self.configureMainTitleLabel()
        self.configureButtons()
        
        square = UIView(frame: CGRect(x: self.scrollView.contentSize.width/5 + 60, y: 350, width: 32, height: 32))
        let imgFrame = square?.frame
        
        square = UIImageView()
        square?.frame = imgFrame!
        let userAdded = UIImage(named: "athlete-face")
        (square as! UIImageView).image = userAdded
        (square as! UIImageView).tintColor = UIColor(hex: 0xffcc66)
        square?.alpha = 0
        self.scrollView.addSubview(square!)
        
    }
    
    
    
    func configureMainTitleLabel() {
    
        var title = UILabel()
        title.textColor = UIColor(hex:0xffffff)
        title.font = UIFont(name: "AvenirNextCondensed-DemiBoldItalic", size: 48.0)
        title.text = "RunWithMe"
    
        title.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(title)
        
        // position the label centrally
        var horizontalConstraint = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(horizontalConstraint)

        // set the y-height for the label
        var topConstraint = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 250)
        self.scrollView.addConstraint(topConstraint)
        
        
        title = UILabel()
        title.textColor = UIColor(hex:0xffcc66)
        title.font = UIFont(name: "Avenir-Heavy", size: 15.0)
        title.text = "Fitness | Friends | Tracking"
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(title)
        
        // position the label centrally
        horizontalConstraint = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        self.scrollView.addConstraint(horizontalConstraint)
        
        // set the y-height for the label
        topConstraint = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.scrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 305)
        
        self.scrollView.addConstraint(topConstraint)
        
        
    }
    
    func configureButtons() {
        
        self.joinButton.layer.cornerRadius = 4.0
        self.joinButton.layer.borderWidth = 1.0
        self.joinButton.layer.borderColor = UIColor.white().cgColor
        self.joinButton.tintColor = UIColor.white()
        self.signInButton.tintColor = UIColor(hex:0xffffff)
    }
    
    
    func configureStartActivityView()
    {
        let startActivityView = StartActivityView.CustomView()
        startActivityView.frame = frame
        self.scrollView.addSubview(startActivityView)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let maximumHorizontalOffset = scrollView.contentSize.width - scrollView.frame.size.width;
        let currentHorizontalOffset = scrollView.contentOffset.x;
        print("Current offset: \(currentHorizontalOffset)")
        
        print("Horizontal offset: \(currentHorizontalOffset/maximumHorizontalOffset) ")
        
        self.didScollToPercentageOffset(horizontalOffset: currentHorizontalOffset/maximumHorizontalOffset)
    }
    
    
    func didScollToPercentageOffset(horizontalOffset: CGFloat) {
        
        self.animateViews(percentage: horizontalOffset)
    }
    
    
    func animateViews(percentage: CGFloat) {
        
        let minScale = 0.1
        let maxScale = 0.75
        
        let scalingFactor = maxScale - minScale
        
        let actualScale = (Double(percentage) - minScale) / scalingFactor

        
        switch percentage {
            
            case 0.25...0.75:
                searchFriendsView?.animateCircles(percentage)
                self.square?.alpha = 1.0
                
                UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubicPaced, animations: {
                    let tX = actualScale * 880
                    print("Translate \(percentage * 100) : \(tX)")
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                        self.square?.transform = CGAffineTransform(translationX: CGFloat(tX), y: 0)
                        
                        self.trackingView?.animatePath(percentage: percentage)
                        
                        // TODO: this should be only called fro page# 3
                        self.trackingView?.animateCurrentLocView(percentage: percentage)
                        
                    })
                    }, completion:nil)
                    
            
            case 0.78...1.0:
                    self.barGraphView?.animateViews(percentage: percentage)
            default:
                    break
        }
    }
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.currentPage
        // Do something with your page update
        print("scrollViewDidEndDecelerating - currentPage: \(currentPage)")
        
        if currentPage != self.currentPage { // check ensures view reaches the end not user trying to track some content
            // set the progressbar to current page
            self.progressStackView.arrangedSubviews[currentPage].backgroundColor = UIColor(hex:0xffcc66)
            self.progressStackView.arrangedSubviews[self.currentPage].backgroundColor = UIColor.lightGray()
            self.currentPage = currentPage
        }
    }
    
  
    
    // determine the direction of the user's pan gesture:
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer .translation(in: scrollView.superview).x > 0 {
            print("panning to the right")
            panRight = true
            panLeft = false
        } else {
            print("panning to the left")
            panLeft = true
            panRight = false
        }
    }
    
}




// extension to compute scrollview page
extension UIScrollView {
    
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)
    }
}


extension UIColor {
    
    convenience init(hex: Int, _ alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green:CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha:  CGFloat(255 * alpha) / 255)
    }
    
}
