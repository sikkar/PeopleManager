//
//  LoadingOverlay.swift
//  PeopleManager
//
//  Created by Angel Escribano on 21/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import UIKit

class LoadingOverlay {
    
    private var contentView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    static let shared: LoadingOverlay = LoadingOverlay()
    
    public func showOverlay(view: UIView) {
        contentView = UIView(frame: UIScreen.main.bounds)
        let background = UIColor.gray
        contentView.backgroundColor = background.withAlphaComponent(0.4)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = contentView.center
        contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(contentView)
    }
    
    public func hideOverlay(){
        activityIndicator.stopAnimating()
        contentView.removeFromSuperview()
    }
}
