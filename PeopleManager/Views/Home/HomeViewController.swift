//
//  HomeViewController.swift
//  PeopleManager
//
//  Created by Angel Escribano on 17/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var peopleCollectionView: UICollectionView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    fileprivate let personCellIdentifier = "personCellIdentifier"
    fileprivate let sectionInsets = UIEdgeInsets(top: 85.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    private let viewModel: PeopleViewModel = PeopleViewModel()
    var lastYPosition: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    func setupView(){
        self.navigationController?.navigationBar.isHidden = true
        self.peopleCollectionView.backgroundColor = UIColor.mainBlue()
        
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self
        peopleCollectionView.register(UINib.init(nibName: "PersonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: personCellIdentifier)
        
        self.view.setTopBarShadow(view: topBarView)
        noDataLabel.text = "NO_DATA_AVAILABLE".localized
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(minimizeView(_:)),
            name: NSNotification.Name(rawValue: NotificationValue.minimizeView.rawValue),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(maximizeView(_:)),
            name: NSNotification.Name(rawValue: NotificationValue.maximizeView.rawValue),
            object: nil)
    }
    
    @objc func bindViewModel(){
        LoadingOverlay.shared.showOverlay(view: self.view)
        viewModel.requestAllPeople { error in
            if let error = error{
                PeopleErrorManager.presentLocalizedError(error: error, inView: self)
                LoadingOverlay.shared.hideOverlay()
            }else {
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlay()
                    if(self.viewModel.peopleList.count == 0){
                        self.view.bringSubview(toFront: self.noDataLabel)
                    } else {
                        self.view.sendSubview(toBack: self.noDataLabel)
                    }
                    self.peopleCollectionView.reloadData()
                }
            }
        }
    }
    
    @objc func minimizeView(_ sender: AnyObject) {
        AnimationHelper.animateWithSpring(duration: 0.7, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.935, y: 0.935)
            //self.peopleCollectionView.transform = CGAffineTransform(scaleX: 0.990, y: 0.990)
        })
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func maximizeView(_ sender: AnyObject) {
        AnimationHelper.animateWithSpring(duration: 0.7, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            //self.peopleCollectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
       UIApplication.shared.statusBarStyle = .default
    }
    @IBAction func addPersonPressed(_ sender: Any) {
        let addPerson = AddPersonViewController.init(nibName: "AddPersonViewController", bundle: nil, viewModel: viewModel)
        addPerson.modalDelegate = self
        addPerson.modalPresentationStyle = .overFullScreen
        navigationController?.present(addPerson, animated: false, completion: nil)
    }
    
}

//MARK:UICollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.peopleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: personCellIdentifier, for: indexPath) as? PersonCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.personModel = viewModel.peopleList[indexPath.row]
        return cell
    }
}

//MARK:UICollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = viewModel.peopleList[indexPath.row]
        let detail = DetailViewController.init(nibName: "DetailViewController", bundle: nil, viewModel: self.viewModel, person: person)
        detail.modalDelegate = self
        detail.modalPresentationStyle = .overFullScreen
        navigationController?.present(detail, animated: false, completion: nil)
    }
    
}

//MARK:UiCollectionViewFlow Delegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

//MARK:Scrollview Delegate
extension HomeViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y > lastYPosition && scrollView.contentOffset.y > 0){
            AnimationHelper.animateView(duration: 0.5, animations: {
                self.topBarView.transform = CGAffineTransform(translationX:0, y: -(self.topBarView.frame.size.height))
            })
        } else {
            AnimationHelper.animateView(duration: 0.5, animations: {
                self.topBarView.transform = CGAffineTransform.identity
            })
        }
        self.lastYPosition = scrollView.contentOffset.y
    }
}

extension HomeViewController: ModalDelegate {
    func reloadViewModel() {
        self.bindViewModel()
    }
}

//MARK:Notifications
enum NotificationValue: String {
    case minimizeView = "minimizeView"
    case maximizeView = "maximizeView"
}

//MARK:Modal Delegate
protocol ModalDelegate {
    func reloadViewModel()
}
