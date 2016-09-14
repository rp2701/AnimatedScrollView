
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
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var progressStackView: UIStackView!
    var panRight = false
    var panLeft = false
    
    var currentPage = 0
    
    // views that make up this scrollView's content
    var searchFriendsView: SearchFriendsView?
    var startActivityView: StartActivityView?
    var trackingView: MonitorActivityView?
    var barGraphView: BarGraphView?
    
    
    var totalOffset : CGFloat?
    
//    static var count = 0
    
    let color2 = 0x66e6ff
    let color1 = 0x6699ff
    let scrollViewCount = 5
    
    var selectedUser : UIImageView?
    
    var frame: CGRect = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let scrollWidth = self.scrollView.frame.size.width
        let scrollHeight = self.scrollView.frame.size.height
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false

        
        for index in 0 ..< scrollViewCount {

            // calculates the frame for each subview to be inserted into scroll view
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            print(frame.size)
            
            switch index {
                case 0:
                    let subView = UIView(frame: frame)
                    let bgView = UIImageView(image: UIImage(named: "app-bg5"))
                    bgView.frame = frame
                    subView.addSubview(bgView)
                    self.scrollView .addSubview(subView)
                case 1:
                    searchFriendsView = SearchFriendsView.CustomView()
                    searchFriendsView?.frame = frame
                    self.scrollView.addSubview(searchFriendsView!)
                case 2:
                    self.startActivityView = StartActivityView.CustomView()
                    self.startActivityView?.frame = frame
                    self.scrollView.addSubview(startActivityView!)
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
        
        // configures scrollView
//        print("ScrollView width: \(self.scrollView.bounds.size.width)")
        self.scrollView.contentSize = CGSize.init(width: scrollWidth * 5, height: scrollHeight)
        
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isScrollEnabled = true
        
        self.configureMainTitleLabel()
        self.configureButtons()
        
        self.selectedUser = UIImageView(frame: CGRect(x: self.scrollView.contentSize.width/5 + 70, y: 350, width: 40, height: 40))
        let imgFrame = self.selectedUser?.frame
        
        
    
        self.selectedUser = UIImageView()
        self.selectedUser?.frame = imgFrame!
        self.selectedUser?.image = UIImage(named: "athlete-face")
        self.selectedUser?.alpha = 0
        self.scrollView.addSubview(self.selectedUser!)
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
        title.font = UIFont(name: "AvenirNextCondensed-Bold", size: 16.0)
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let maximumHorizontalOffset = scrollView.contentSize.width - scrollView.frame.size.width;
        let currentHorizontalOffset = scrollView.contentOffset.x;
        print("Horizontal offset: \(currentHorizontalOffset/maximumHorizontalOffset) ")
        
        self.didScollToPercentageOffset(horizontalOffset: currentHorizontalOffset/maximumHorizontalOffset)
    }
    
    
    func didScollToPercentageOffset(horizontalOffset: CGFloat) {
        
        self.animateViews(percentage: horizontalOffset)
    }
    
    
    func animateViews(percentage: CGFloat) {
        
        switch percentage {
            
            case 0.25:
                searchFriendsView?.animateUsers(percentage)
            
                UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.selectedUser?.transform = CGAffineTransform(translationX: (self.searchFriendsView?.position1)!, y: 0) //
                        self.selectedUser?.alpha = 1.0
                    }, completion: nil)
            case 0.5:
                if self.panLeft {
                    self.startActivityView?.animateIcons(percentage: percentage)
                }
                fallthrough
            case 0.5...0.75:
                self.trackingView?.animatePath(percentage: percentage)
                self.trackingView?.animateCurrentLocView(percentage: percentage)
                fallthrough
            case 0.25...0.75:
                 self.animateSelectedUser(percentage)
            case 0.78...1.0:
                self.barGraphView?.animateViews(percentage: percentage)
            default:
                break
        }
    }
    
    
    func animateSelectedUser(_ percentage: CGFloat) {
        
        if totalOffset == nil {
           
            totalOffset = (self.searchFriendsView?.position2)! + (self.startActivityView?.bounds.width)! + (self.trackingView?.position4)!
            
            print("Total Offset: \(totalOffset!)")
        }
        
        let minScale = 0.12
        let maxScale = 0.75
        let scalingFactor = maxScale - minScale
        let actualScale = (Double(percentage) - minScale) / scalingFactor
        
        UIView.animateKeyframes(withDuration: 0, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubicPaced, animations: {
            
                let tX = actualScale * Double(self.totalOffset!) // REMOVE  hardwired value
//                let tX = actualScale * 875// REMOVE  hardwired value
                print("Translate \(percentage * 100) : \(tX)")
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.selectedUser?.alpha = 1.0
                self.selectedUser?.transform = CGAffineTransform(translationX: CGFloat(tX), y: 0)
            })
        }, completion:nil)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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


extension UIImageView {
    func blurImage() {
        
        let blurEffect = UIBlurEffect(style: .extraLight  )
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        self.addSubview(blurEffectView)
    }
}
