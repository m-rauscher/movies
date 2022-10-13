//
//  GenreDetailCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 06.10.22.
//

import UIKit

class GenreDetailCell: UICollectionViewCell {    
    @IBOutlet weak var genreTitel: UILabel!
    
    func setUpView(genre: String){
        genreTitel.text = genre
        self.layer.cornerRadius = 11
        genreTitel.font = UIFont.systemFont(ofSize: 14, weight: .light)
    }
}
