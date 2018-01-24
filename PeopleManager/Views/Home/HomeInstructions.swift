//
//  HomeInstructions.swift
//  PeopleManager
//
//  Created by Angel Escribano on 23/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit
import Instructions

extension HomeViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !(UserDefaults.standard.value(forKey: tutorialHomeKey) as? Bool ?? false) {
            self.coachMarkHelper.controller.start(on: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarkHelper.controller.stop(immediately: true)
    }
    
    func setupInstructions() {
        coachMarkHelper = CoachMarkHelper.init(views: [addPersonButton, filterPeopleButton],
                                               texts: [
                                                ["ADD_PEOPLE_MARK_TEXT".localized:"ADD_PEOPLE_MARL_BUTTON".localized],
                                                ["FILTER_PEOPLE_MARK_TEXT".localized:"FILTER_PEOPLE_MARK_BUTTON".localized]
                                                ],
                                               userDefaultsKey: tutorialHomeKey)
    }
    
}
