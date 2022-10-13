//
//  SeeAllCollectionViewCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 04.10.22.
//

import UIKit

class SeeAllHomeCell: UICollectionViewCell {
    @IBOutlet weak var seeAllButton: UIImageView!
    
    func setUpView(){
        self.dropShadow(color: UIColor.black, opacity: 0.9, offSet: CGSize(width: 0, height: 4), radius: 20)
    }
}
