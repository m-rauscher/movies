//
//  PersonDetailCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 06.10.22.
//

import UIKit

class PersonDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var character: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func setUpView(person: Person){
        
        image.downloaded(from: person.pictureUrl)
        image.layer.cornerRadius = 12
        
        name.text = person.name
        name.lineBreakMode = .byWordWrapping
        name.numberOfLines = 0
        
        character.text = person.character
        character.lineBreakMode = .byWordWrapping
        character.numberOfLines = 0
        
        self.dropShadow(color: UIColor.black, opacity: 0.4, offSet: CGSize(width: 0, height: 4), radius: 15)
    }
}
