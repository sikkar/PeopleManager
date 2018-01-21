//
//  AnimationHelper.swift
//  PeopleManager
//
//  Created by Angel Escribano on 20/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class AnimationHelper: NSObject {
    
    public class func animateWithSpring(duration: TimeInterval, animations: @escaping () -> Void){
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: {
                animations()
        },
            completion: nil
        )
    }
    
    public class func animateWithSpringCompletion(duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void){
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: {
                animations()
        }) { finished in
            completion(finished)
        }
    }
    
    public class func animateView(duration: TimeInterval, animations: @escaping() -> Void) {
        UIView.animate(
            withDuration: duration,
            animations: {
                animations()
        },
            completion: nil
        )
    }
    
}
