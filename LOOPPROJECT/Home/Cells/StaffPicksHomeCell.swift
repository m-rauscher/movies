//
//  StaffPicksCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 10.10.22.
//

import UIKit

class StaffPicksHomeCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteFlag: UIButton!
    @IBOutlet weak var seperator: UIImageView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var titel: UILabel!
    @IBOutlet weak var ratingImg: UIImageView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var posterView: UIView!
    
    func setUpView(film: Film){
        seperator.image = UIImage(named: "FavoriteTrennlinie")
        
        year.text = String(film.releaseDate.prefix(4))
        
        posterImg.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: 0, height: 4), radius: 15)
        posterImg.downloaded(from: film.posterUrl)
        posterImg.layer.cornerRadius = 10
        posterView.layer.cornerRadius = 10
        posterView.clipsToBounds = true
        
        ratingImg.image = Rating(rating: film.rating, colorMode: "Dark").getImage()
        
        titel.text = film.title
        
        favoriteFlag.setImage(UIImage(named: "FavoriteFlagDark"), for: .normal)
        favoriteFlag.setImage(UIImage(named: "FavoriteFlagDarkSelected"), for: .selected)
        favoriteFlag.addTarget(self, action: #selector(flagPressed), for: .touchUpInside)
        favoriteFlag.isSelected = film.favorite ?? false
    }
    
    @objc
    func flagPressed(_ button: UIButton) {
        button.isSelected.toggle()
    }
}
