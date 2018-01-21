//
//  ErrorManager.swift
//  PeopleManager
//
//  Created by Angel Escribano on 21/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

struct PeopleError: Error {
    var message : String
    var errorCode : String
}

struct PeopleErrorManager {
    
    static func presentLocalizedError(error : PeopleError, inView vc: UIViewController) {
        
        let alert = UIAlertController(title: "ERROR".localized, message: error.errorCode + ": " + error.message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(defaultAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
}
