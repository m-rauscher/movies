//
//  OverviewDetailCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 06.10.22.
//

import UIKit

class OverviewDetailCell: UICollectionViewCell {
    

    @IBOutlet weak var overview: UILabel!
    
    func setUpView(text:  String){
        
        overview.text = text
        overview.lineBreakMode = .byWordWrapping
        overview.numberOfLines = 0
        overview.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
}
