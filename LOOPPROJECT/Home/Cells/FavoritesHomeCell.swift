//
//  FavoritesCollectionViewCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 10.10.22.
//

import UIKit

class FavoritesHomeCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!
    
    func setUpView(film: Film){
        posterImg.downloaded(from: film.posterUrl)
        posterImg.layer.cornerRadius = 14
        
        self.dropShadow(color: UIColor.black, opacity: 0.6, offSet: CGSize(width: 0, height: 10), radius: 30)
        self.contentView.layer.cornerRadius = 14
    }
}
