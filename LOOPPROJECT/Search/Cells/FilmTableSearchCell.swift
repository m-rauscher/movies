//
//  SearchTableViewCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 04.10.22.
//

import UIKit

class FilmTableSearchCell: UITableViewCell {


    @IBOutlet weak var posterImage: UIImageView!

    @IBOutlet weak var titel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var linie: UIImageView!
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var favoriteFlag: UIButton!
    
    func setUpView(film: Film){
        titel.text = film.title
        releaseDate.text = String( film.releaseDate.prefix(4))
        posterImage.downloaded(from: film.posterUrl)
        posterImage.layer.cornerRadius = 10
        rating.image = getRatingImage(rating: film.rating)
        linie.image = UIImage(named: "FavoriteTrennlinie")
        
        
        favoriteFlag.setImage(UIImage(named: "FavoriteFlagDark"), for: .normal)
        favoriteFlag.setImage(UIImage(named: "FavoriteFlagDarkSelected"), for: .selected)
        favoriteFlag.addTarget(self, action: #selector(flagPressed), for: .touchUpInside)
        favoriteFlag.isSelected = film.favorite ?? false
        
    }
    func getRatingImage(rating: Float) -> UIImage{
        
        let ratingInt = (Int)(rating + 0.5)
        
        switch ratingInt {
        case 2:
            return UIImage(named: "2starDark")!
        case 3:
            return UIImage(named: "3starDark")!
        case 4:
            return UIImage(named: "4starDark")!
        case 5:
            return UIImage(named: "5starDark")!
        default:
            return UIImage(named: "1starDark")!
        }
    }
    @objc
    func flagPressed(_ button: UIButton) {
        button.isSelected.toggle()
    }
}
