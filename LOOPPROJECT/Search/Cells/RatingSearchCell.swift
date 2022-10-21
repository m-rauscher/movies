//
//  RatingSearchCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 05.10.22.
//

import UIKit

class RatingSearchCell: UICollectionViewCell {
    
    @IBOutlet weak var ratingImg: UIImageView!
    
    @IBOutlet weak var ratingVIew: UIView!
    var ratingColor = UIColor.white
    
    func setUpView(starsCount: Int){
        
        let ratingString = "searchStar" + String(starsCount)
        ratingImg.image = UIImage(named: ratingString)?.withRenderingMode(.alwaysTemplate)
        
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}
