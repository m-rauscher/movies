//
//  FactsDetailCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 12.10.22.
//

import UIKit

class FactsDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var dateDuration: UILabel!
    @IBOutlet weak var titelYear: UILabel!
    @IBOutlet weak var ratingImg: UIImageView!
    
    func setUpView(film: Film){
        
        ratingImg.image = getRatingImage(rating: film.rating)
        
        //get Date String -------- "releaseDate" : "2016-06-16",
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: film.releaseDate)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date!)
        
        //get Duration String in h and min ------- "runtime" : 120
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        let runtimeString = formatter.string(from: TimeInterval(film.runtime * 60))
        
        dateDuration.text = dateString + "  ·  " + (runtimeString ?? "")
       
        var titleString = film.title
        if film.title.count > 20{
            titleString = String(film.title.prefix(20)) + "..."
        }
        let yearString = " (" + film.releaseDate.prefix(4) + ")"
        
        let attributedTitle = NSMutableAttributedString(string: titleString, attributes: [
            .font: UIFont.systemFont(ofSize: 24, weight: .heavy),
            .foregroundColor: UIColor(named: "Background") ?? UIColor.black
        ])
        let yearAttributedString = NSAttributedString(string: yearString, attributes: [
            .font: UIFont.systemFont(ofSize: 24, weight: .light),
            .foregroundColor: UIColor(named: "MediumEmphasis") ?? UIColor.gray
        ])
     
        attributedTitle.append(yearAttributedString)
        titelYear.attributedText = attributedTitle
    }

    
    func getRatingImage(rating: Float) -> UIImage{
        let ratingInt = (Int)(rating + 0.5)
        switch ratingInt {
        case 2:
            return UIImage(named: "2starLight")!
        case 3:
            return UIImage(named: "3starLight")!
        case 4:
            return UIImage(named: "4starLight")!
        case 5:
            return UIImage(named: "5starLight")!
        default:
            return UIImage(named: "1starLight")!
        }
    }
}
