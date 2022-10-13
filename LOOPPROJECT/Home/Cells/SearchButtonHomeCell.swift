//
//  SearchButtonHomeCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 10.10.22.
//

import UIKit

class SearchButtonHomeCell: UICollectionViewCell {
    
    @IBOutlet weak var searchButton: UIButton!
    
    func setUpView(){        
        searchButton.layer.cornerRadius = 12
        self.dropShadow(color: UIColor.black, opacity: 0.16, offSet: CGSize(width: 0, height: 0), radius: 15)
    }
}
