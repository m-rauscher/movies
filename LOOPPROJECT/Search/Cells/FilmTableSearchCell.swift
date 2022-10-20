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
        rating.image = Rating(rating: film.rating, colorMode: "Dark").getImage()
        linie.image = UIImage(named: "Separator")
        
        
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
