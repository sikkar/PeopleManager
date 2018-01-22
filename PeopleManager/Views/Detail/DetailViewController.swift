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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    
    var viewModel: PeopleViewModel?
    var person: Person?
    var modalDelegate: ModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindPerson()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postNotification(value: NotificationValue.minimizeView.rawValue)
        let amountToTranslate = self.view.bounds.width / 2 + (self.personDetailsView.bounds.width / 2)
        AnimationHelper.animateWithSpring(duration: 0.5, animations: {
            self.personDetailsView.transform = CGAffineTransform.identity.translatedBy(x: amountToTranslate, y: 0)
        })
        
    }
    
    //MARK:Init
    convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: PeopleViewModel, person: Person){
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.viewModel = viewModel
        self.person = person
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    private func setupView(){
        view.setCellsShadow(view: personDetailsView)
        view.setCellsShadow(view: dataView)
        let background = UIColor.gray
        let dimmedBackground = background.withAlphaComponent(0.4)
        self.view.backgroundColor = dimmedBackground
        nameLabel.text = "NAME_LABEL".localized
        birthdayLabel.text = "BIRTHDAY_LABEL".localized
    }
    
    private func bindPerson(){
        self.nameLabel.text = person?.name
        self.birthdayLabel.text = person?.birthdate?.dateToString
    }
    
    //MARK: Events
    @IBAction func dismissViewController(_ sender: Any) {
        let amountToTranslate = self.personDetailsView.bounds.width + self.view.bounds.width
        dismissAnimation(translationX: amountToTranslate, translationY: 0)
    }
    @IBAction func userDeletionPressed(_ sender: Any) {
        LoadingOverlay.shared.showOverlay(view: self.view)
        if let personId = self.person?.id{
            viewModel?.requestDeletePerson(personId: personId, completionHandler: { error in
                LoadingOverlay.shared.hideOverlay()
                if let removeError = error {
                    PeopleErrorManager.presentLocalizedError(error: removeError, inView: self)
                }else {
                    let deleteTranslationY = (self.personDetailsView.bounds.height / 2 + self.view.bounds.height / 2)
                    let deleteTranslationX = deleteTranslationY-(self.personDetailsView.bounds.height / 2)
                    self.dismissAnimation(translationX: deleteTranslationX, translationY: deleteTranslationY)
                    if let modalDelegate = self.modalDelegate {
                        modalDelegate.reloadViewModel()
                    }
                }
            })
        }
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        let editTranslationY = (self.personDetailsView.bounds.height / 2 + self.view.bounds.height / 2)
        let editTranslationX = editTranslationY-(self.personDetailsView.bounds.height / 2)
        dismissAnimation(translationX: editTranslationX, translationY: -(editTranslationY + 20))
    }
    
    func dismissAnimation(translationX: CGFloat, translationY: CGFloat){
        postNotification(value: NotificationValue.maximizeView.rawValue)
        AnimationHelper.animateWithSpringCompletion(duration: 0.5, animations: {
            self.personDetailsView.transform = CGAffineTransform(translationX: translationX , y: translationY)
        }) { finished in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
//MARK:Notification Extension
extension UIViewController {
    func postNotification(value: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: value), object: nil)
    }
}
