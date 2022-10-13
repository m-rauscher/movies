//
//  HeaderHome.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 10.10.22.
//

import UIKit

class HeaderHome: UICollectionReusableView {
        
    @IBOutlet weak var header: UILabel!
    
    func setUpView(section: Int){
        switch section {
        case 1:
            let text = "YOUR FAVORITES" as NSString
            let attText = NSMutableAttributedString(string: text as String)
            let boldString = "FAVORITES"
            let boldRange = text.range(of: boldString)
            let font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(700))
            attText.addAttribute(NSAttributedString.Key.font, value: font, range: boldRange)
            header.attributedText = attText
            header.textColor = UIColor(named: "High Emphasis")
        case 2:
            let text = "OUR STAFF PICKS" as NSString
            let attText = NSMutableAttributedString(string: text as String)
            let boldString = "STAFF PICKS"
            let boldRange = text.range(of: boldString)
            let font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(700))
            attText.addAttribute(NSAttributedString.Key.font, value: font, range: boldRange)
            header.attributedText = attText
            header.textColor = UIColor(named: "High Emphasis Light")
        default:
            break
        }
    }
}
