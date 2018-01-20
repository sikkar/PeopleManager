//
//  PersonTableViewCell.swift
//  PeopleManager
//
//  Created by Angel Escribano on 19/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var personModel: Person? {
        didSet {
            bindPersonModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10.0
    }
    
    func bindPersonModel(){
        nameLabel?.text = personModel?.name
    }
    
}
