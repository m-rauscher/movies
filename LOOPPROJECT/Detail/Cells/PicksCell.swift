//
//  PicksCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 03.10.22.
//

import UIKit

class PicksCell: UITableViewCell {
    
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var linie: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    var isOn = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonPressed(_ sender: Any) {
        isOn.toggle()
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
}
