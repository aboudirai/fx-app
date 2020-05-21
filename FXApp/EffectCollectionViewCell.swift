//
//  EffectCollectionViewCell.swift
//  FXApp
//
//  Created by Aboudi Rai on 5/12/20.
//  Copyright © 2020 Shackamaxon Technologies. All rights reserved.
//

import UIKit

class EffectCollectionViewCell: UICollectionViewCell {

    class var reuseIdentifier: String {
        return "EffectCollectionViewCellReuseIdentifier"
    }
    
    class var nibName: String {
        return "EffectCollectionViewCell"
    }
    
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(name: String){
        self.name.text = name
    }

}


