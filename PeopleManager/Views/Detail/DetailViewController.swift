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
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var enableEditButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    let datepickerView: UIDatePicker = UIDatePicker()
    var viewModel: PeopleViewModel?
    var person: Person?
    var modalDelegate: ModalDelegate?
    var isEditingPerson: Bool = false
    
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
        datepickerView.isHidden = true
        nameLabel.text = "NAME_LABEL".localized
        birthdayLabel.text = "BIRTHDAY_LABEL".localized
        editButton.titleLabel?.text = "EDIT_PERSON_BUTTON".localized
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissInputViews))
        view.addGestureRecognizer(tap)
    }
    
    private func bindPerson(){
        self.nameLabel.text = person?.name
        self.birthdayLabel.text = person?.birthdate?.dateToString
        self.nameTextField.text = person?.name
        self.birthdayTextField.text = person?.birthdate?.dateToString
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
        if !isEditingPerson {
            isEditingPerson = true
            let translateDistance = self.editButton.bounds.width
            AnimationHelper.animateWithSpring(duration: 0.5) {
                self.enableEditButton.transform = CGAffineTransform(translationX: translateDistance, y: 0)
                self.editButton.alpha = 1
                self.nameTextField.alpha = 1
                self.birthdayTextField.alpha = 1
                self.nameLabel.alpha = 0
                self.birthdayLabel.alpha = 0
            }
        } else {
            isEditingPerson = false
            AnimationHelper.animateWithSpring(duration: 0.5) {
                self.enableEditButton.transform = CGAffineTransform.identity
                self.editButton.alpha = 0
                self.nameTextField.alpha = 0
                self.birthdayTextField.alpha = 0
                self.nameLabel.alpha = 1
                self.birthdayLabel.alpha = 1
            }
        }
    }
    
    @IBAction func finishEditPressed(_ sender: Any) {
        dismissInputViews()
         if(!(nameTextField.text?.isEmpty)! && !(birthdayTextField.text?.isEmpty)!){
            if let name = nameTextField.text, let birth = birthdayTextField.text, var person = self.person {
                LoadingOverlay.shared.showOverlay(view: self.view)
                person.name = name
                person.birthdate = birth.stringToDate
                viewModel?.requestUpdatePerson(person: person, completionHandler: { error in
                    LoadingOverlay.shared.hideOverlay()
                    if let updateError = error {
                        PeopleErrorManager.presentLocalizedError(error: updateError, inView: self)
                    }else {
                        if let modalDelegate = self.modalDelegate {
                            modalDelegate.reloadViewModel()
                        }
                        let editTranslationY = (self.personDetailsView.bounds.height / 2 + self.view.bounds.height / 2)
                        let editTranslationX = editTranslationY-(self.personDetailsView.bounds.height / 2)
                        self.dismissAnimation(translationX: editTranslationX, translationY: -(editTranslationY + 20))
                    }
                })
            }
        }
        
    }
    
    @IBAction func birthdayEditingStarted(_ sender: UITextField) {
        datepickerView.isHidden = false
        datepickerView.datePickerMode = .date
        if let date = self.person?.birthdate {
            datepickerView.setDate(date, animated: false)
        }
        sender.inputView = datepickerView
        datepickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        birthdayTextField.text = sender.date.dateToString
    }
    
    func dismissAnimation(translationX: CGFloat, translationY: CGFloat){
        dismissInputViews()
        postNotification(value: NotificationValue.maximizeView.rawValue)
        AnimationHelper.animateWithSpringCompletion(duration: 0.5, animations: {
            self.personDetailsView.transform = CGAffineTransform(translationX: translationX , y: translationY)
        }) { finished in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func dismissInputViews(){
        nameTextField.resignFirstResponder()
        if !datepickerView.isHidden{
            birthdayTextField.resignFirstResponder()
        }
    }
}
//MARK:Notification Extension
extension UIViewController {
    func postNotification(value: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: value), object: nil)
    }
}
