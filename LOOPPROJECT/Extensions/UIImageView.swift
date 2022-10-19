//
//  UIImageView.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 10.10.22.
//

import Foundation
import UIKit

extension UIImageView {
        func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
            contentMode = mode
            let networker = NetworkManager.shared
            let url = URL(string: link)!
            
            networker.downloadImage(imageURL: url, completion: { (data,error) in
                if let error = error {
                  print(error)
                  return
                }
                self.image = UIImage(data: data!)
            })
        }
}
