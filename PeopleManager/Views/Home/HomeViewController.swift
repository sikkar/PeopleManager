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
    
    fileprivate let personCellIdentifier = "personCellIdentifier"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    private let viewModel: PeopleViewModel = PeopleViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        peopleCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView(){
        self.navigationController?.navigationBar.isHidden = true
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self
        peopleCollectionView.register(UINib.init(nibName: "PersonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: personCellIdentifier)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(minimizeView(_:)),
            name: NSNotification.Name(rawValue: "minimizeView"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(maximizeView(_:)),
            name: NSNotification.Name(rawValue: "maximizeView"),
            object: nil)
    }
    
    func bindViewModel(){
        viewModel.requestAllPeople {
            DispatchQueue.main.async {
               self.peopleCollectionView.reloadData()
            }
        }
    }
    
    @objc func minimizeView(_ sender: AnyObject) {
        AnimationHelper.animateThis(duration: 0.7, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.935, y: 0.935)
            self.peopleCollectionView.transform = CGAffineTransform(scaleX: 0.990, y: 0.990)
        })
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func maximizeView(_ sender: AnyObject) {
        AnimationHelper.animateThis(duration: 0.7, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.peopleCollectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
       UIApplication.shared.statusBarStyle = .default
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
        let detail = DetailViewController()
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
        
        return CGSize(width: widthPerItem, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
