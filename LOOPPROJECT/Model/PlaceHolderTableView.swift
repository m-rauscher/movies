//
//  PlaceHolderTableView.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 06.10.22.
//

import Foundation
import UIKit

class PlaceholderTableView: UITableView {
    @IBOutlet var placeholder: UIView?
    @IBInspectable var emptiableSection:Int = 0


    override func reloadData() {
        super.reloadData()
        let count = self.numberOfRows(inSection: emptiableSection)
        self.placeholder?.isHidden =  (count != 0)
    }
}
