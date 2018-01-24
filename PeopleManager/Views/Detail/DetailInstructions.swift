//
//  DetailInstructions.swift
//  PeopleManager
//
//  Created by Angel Escribano on 24/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit
import Instructions

extension DetailViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coachMarkHelper.controller.stop(immediately: true)
    }
    
    func setupInstructions() {
        coachMarkHelper = CoachMarkHelper.init(views: [enableEditButton, deletePersonButton],
                                               texts: [
                                                ["EDIT_PERSON_MARK_TEXT".localized:"EDIT_PERSON_BUTTON_TEXT".localized],
                                                ["DELETE_PERSON_MARK_TEXT".localized:"DELETE_PERSON_BUTTON_TEXT".localized]
            ],
                                               userDefaultsKey: tutorialDetailKey)
    }
}
