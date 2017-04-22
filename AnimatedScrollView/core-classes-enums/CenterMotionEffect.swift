//
//  CenterMotionEffect.swift
//  RunWithMe
//
//  Created by Rupesh Pandey on 9/24/16.
//  Copyright © 2016 Creative Gray Inc. All rights reserved.
//

import Foundation
import UIKit


/* This class builds a motion effect group from two separate UIInterpolatingMotionEffect
 * instances. The effect is interpolated along the vertical and horizontal axes for a view's
 * center property. By changing the keypath to layer.shadowOffset.width and height for 
 * motion effects to work with shadows.
 */
class CenterMotionEffect : UIMotionEffectGroup {
    
    static func effectWithMagnitude(magnitude: CGFloat) -> CenterMotionEffect {
        
        let hEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        hEffect.minimumRelativeValue = -1 * fabs(magnitude)
        hEffect.maximumRelativeValue = fabs(magnitude)
        
        let vEffect = UIInterpolatingMotionEffect(keyPath: "cener.y", type: .tiltAlongVerticalAxis)
        vEffect.minimumRelativeValue = -1 * fabs(magnitude)
        vEffect.maximumRelativeValue = fabs(magnitude)
        
        let group = CenterMotionEffect()
        group.motionEffects = [hEffect, vEffect]
        
        return group
    }
}
