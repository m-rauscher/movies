//
//  RatingImage.swift
//  Movies
//
//  Created by Moritz Rauscher on 19.10.22.
//

import Foundation
import UIKit

class Rating {
    let rating: Float
    let colorMode: String
    
    init(rating: Float, colorMode: String) {
        self.rating = rating
        self.colorMode = colorMode
    }
    
    func getImage() -> UIImage{
        let ratingInt = (Int)(rating + 0.5)
        switch ratingInt {
        case 2:
            return UIImage(named: "2star" + colorMode) ?? UIImage()
        case 3:
            return UIImage(named: "3star" + colorMode) ?? UIImage()
        case 4:
            return UIImage(named: "4star" + colorMode) ?? UIImage()
        case 5:
            return UIImage(named: "5star" + colorMode) ?? UIImage()
        default:
            return UIImage(named: "1star" + colorMode) ?? UIImage()
        }
    }
    
}
