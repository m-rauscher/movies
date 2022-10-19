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
        
        self.overview.text = text
        self.overview.lineBreakMode = .byWordWrapping
        self.overview.numberOfLines = 0
        self.overview.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
}
