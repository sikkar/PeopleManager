//
//  PersonCollectionViewCell.swift
//  PeopleManager
//
//  Created by Angel Escribano on 20/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customContentView: UIView!
    
    var personModel: Person?{
        didSet{
            bindPerson()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setCellsShadow(view: customContentView)
    }
    
    private func bindPerson(){
        self.nameLabel.text = self.personModel?.name
    }

}
