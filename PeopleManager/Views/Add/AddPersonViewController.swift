//
//  AddPersonViewController.swift
//  PeopleManager
//
//  Created by Angel Escribano on 21/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class AddPersonViewController: UIViewController {
    @IBOutlet weak var personDataView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var addPersonButton: UIButton!
    @IBOutlet weak var personDataLabel: UILabel!
    
    
    let datepickerView: UIDatePicker = UIDatePicker()
    var viewModel: PeopleViewModel?
    var modalDelegate: ModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postNotification(value: NotificationValue.minimizeView.rawValue)
        let amountToTranslate = self.personDataView.bounds.width + 20
        AnimationHelper.animateWithSpring(duration: 0.5) {
            self.personDataView.transform =  CGAffineTransform.identity.translatedBy(x: -amountToTranslate, y: 0)
        }
    }

    func setupView(){
        view.setCellsShadow(view: personDataView)
        let background = UIColor.gray
        let dimmedBackground = background.withAlphaComponent(0.4)
        self.view.backgroundColor = dimmedBackground
        datepickerView.isHidden = true
        nameTextField.placeholder = "NAME_LABEL".localized
        birthTextField.placeholder = "BIRTH_LABEL".localized
        personDataLabel.text = "PERSON_DATA_LABEL".localized
    }
    
    //MARK:Init
    convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: PeopleViewModel){
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func dismissProcess(){
        postNotification(value: NotificationValue.maximizeView.rawValue)
        let amountToTranslate = self.personDataView.bounds.width + 20
        AnimationHelper.animateWithSpringCompletion(duration: 0.5, animations: {
            self.personDataView.transform = CGAffineTransform(translationX: amountToTranslate, y: 0)
        }) { finished in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK: Events
    @IBAction func dismissViewController(_ sender: Any) {
        nameTextField.resignFirstResponder()
        if !datepickerView.isHidden{
            birthTextField.resignFirstResponder()
            datepickerView.isHidden = true
        } else {
            dismissProcess()
        }
    }
    
    @IBAction func addPeoplePressed(_ sender: Any) {
        nameTextField.resignFirstResponder()
        if !datepickerView.isHidden{
            birthTextField.resignFirstResponder()
            datepickerView.isHidden = true
        }
        if(!(nameTextField.text?.isEmpty)! && !(birthTextField.text?.isEmpty)!){
            LoadingOverlay.shared.showOverlay(view: self.view)
            viewModel?.requestAddPerson(name: nameTextField.text!, birthdate: (birthTextField.text?.stringToDate)!,
                                        completionHandler: { error in
                                            LoadingOverlay.shared.hideOverlay()
                                            if let addError = error {
                                                PeopleErrorManager.presentLocalizedError(error: addError, inView: self)
                                            }else {
                                                if let modalDelegate = self.modalDelegate {
                                                    modalDelegate.reloadViewModel()
                                                }
                                                self.dismissProcess()
                                            }
            })
        }
    }
    
    @IBAction func birthdateEditingStarted(_ sender: UITextField) {
        datepickerView.isHidden = false
        datepickerView.datePickerMode = .date
        sender.inputView = datepickerView
        datepickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        birthTextField.text = sender.date.dateToString
    }

}
