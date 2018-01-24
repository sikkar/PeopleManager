//
//  CoachMarkHelper.swift
//  PeopleManager
//
//  Created by Angel Escribano on 24/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit
import Instructions

class CoachMarkHelper: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    var coachMarkViews: [UIView] = []
    var coachMarkTexts: [[String:String]] = [[:]]
    var controller: CoachMarksController = CoachMarksController ()
    var userDefaultsKey: String?
    
    init() {
        
    }
    
    init(views: [UIView], texts: [[String:String]], userDefaultsKey: String) {
        self.coachMarkViews = views
        self.coachMarkTexts = texts
        self.userDefaultsKey = userDefaultsKey
        self.controller.dataSource = self
        self.controller.overlay.color = UIColor.dimmedGray()
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        
        switch index {
        case 0:
            for (key, value) in coachMarkTexts[0] {
                coachViews.bodyView.hintLabel.text = key
                coachViews.bodyView.nextLabel.text = value
            }
        case 1:
            for (key, value) in coachMarkTexts[1] {
                coachViews.bodyView.hintLabel.text = key
                coachViews.bodyView.nextLabel.text = value
            }
            if let userDefaultsKey = self.userDefaultsKey {
                UserDefaults.standard.setValue(true, forKey: userDefaultsKey)
            }
        default:
            break
        }
        
        return(bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: coachMarkViews[index])
    }
    
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    
}
