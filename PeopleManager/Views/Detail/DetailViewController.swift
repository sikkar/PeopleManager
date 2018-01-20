//
//  DetailViewController.swift
//  PeopleManager
//
//  Created by Angel Escribano on 20/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var personDetailsView: UIView!
    @IBOutlet weak var dissmisButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "minimizeView"), object: nil)
        let amountToTranslate = self.view.bounds.width / 2 + (self.personDetailsView.bounds.width / 2)
        AnimationHelper.animateThis(duration: 0.5, animations: {
            self.personDetailsView.transform = CGAffineTransform.identity.translatedBy(x: amountToTranslate, y: 0)
        })
        
    }
    
    func setupView(){
        personDetailsView.layer.cornerRadius = 10.0
        let background = UIColor.gray
        let dimmedBackground = background.withAlphaComponent(0.4)
        self.view.backgroundColor = dimmedBackground
    }
    
   
    @IBAction func dismissViewController(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "maximizeView"), object: nil)
        let amountToTranslate = self.personDetailsView.bounds.width + self.view.bounds.width
        AnimationHelper.animateWithCompletion(duration: 0.5, animations: {
             self.personDetailsView.transform = CGAffineTransform(translationX: amountToTranslate, y: 0)
        }) { finished in
            self.dismiss(animated: false, completion: nil)
        }
    }

}
