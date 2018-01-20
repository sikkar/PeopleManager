//
//  AnimationHelper.swift
//  PeopleManager
//
//  Created by Angel Escribano on 20/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class AnimationHelper: NSObject {
    
    public class func animateThis(duration: TimeInterval, animations: @escaping () -> Void){
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: [],
            animations: {
                animations()
        },
            completion: nil
        )
    }
    
    public class func animateWithCompletion(duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void){
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
            animations()
        }) { finished in
            completion(finished)
        }
    }
    
}
