//
//  PosterDetailCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 12.10.22.
//

import UIKit

class PosterDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!
    
    func setUpView(film: Film){
        posterImg.downloaded(from: film.posterUrl)
        posterImg.layer.cornerRadius = 16
        
        self.dropShadow(color: UIColor.black, opacity: 0.5, offSet: CGSize(width: 0, height: 4), radius: 20)
    }
    
}
