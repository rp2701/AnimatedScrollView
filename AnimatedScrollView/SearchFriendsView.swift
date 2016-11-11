//
//  SearchFriends.swift
//  AnimatedScrollView
//
//  Created by Rupesh Pandey on 9/5/16.
//  Copyright © 2016 CreativeGray. All rights reserved.
//

import UIKit

class SearchFriendsView: UIView {
    
    @IBOutlet weak var user2: UIImageView!
    @IBOutlet weak var user1: UIImageView!
    @IBOutlet weak var searchUsers: UIImageView!
    
    @IBOutlet weak var selectedUser: UIImageView!
    @IBOutlet weak var selectedUserPosition1: UIView!
    
    var searchUsersViewAnimated = false
    
    static func CustomView() -> SearchFriendsView {
        
        return (Bundle.main.loadNibNamed("SearchFriends", owner: self, options: nil)! .last as? SearchFriendsView)!
    }
    
    
    @IBOutlet weak var selectedUserPos1: NSLayoutConstraint!
    
    var position1 : CGFloat {
        
        get {
            return selectedUserPosition1.frame.origin.x - selectedUser.frame.origin.x
        }
    }
    
    
    var position2 : CGFloat {
        
        get {
            print("Position2: \(selectedUserPosition1.frame.origin.x + selectedUserPosition1.frame.size.width)")
            return selectedUserPosition1.frame.origin.x + selectedUserPosition1.frame.size.width
        }
    }
    
    
    override func awakeFromNib() {
        
        self.user1.alpha = 0
        self.user2.alpha = 0
    
        self.searchUsers.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
    
        super.awakeFromNib()
        print("Position 1 \(self.selectedUserPos1.constant)")
    }
    
    
    override func layoutSubviews() {
        
        self.user1.transform = CGAffineTransform(translationX: -self.position1, y: 50.0)
        self.user2.transform = CGAffineTransform(translationX: -self.position1, y: -50.0)
    }
    
    
    func animateUsers(_ percentage: CGFloat) {
        
        if self.searchUsersViewAnimated == false {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.5,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            self.searchUsers?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                 
                        }, completion: { _ in
                            
                            // back to identity transform
                            UIView.animate(withDuration: 0.7, animations: {
                                
                                self.searchUsers?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            })
            })
            
            self.searchUsersViewAnimated = true
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            
            self.user1.alpha = 1.0
            self.user2.alpha = 1.0
            self.user1.transform = CGAffineTransform(translationX: 0, y: 0)
            self.user2.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
    }
}


