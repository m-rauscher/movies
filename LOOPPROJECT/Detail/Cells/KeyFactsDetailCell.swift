//
//  KeyFactsDetailCell.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 06.10.22.
//

import UIKit

class KeyFactsDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var factValue: UILabel!
    @IBOutlet weak var factTitel: UILabel!
    
    func setUpView(titel: String, value: String){
        factTitel.text = titel
        factValue.text = value
    }
    func setUpView(film: Film, factNmbr: Int){
        switch factNmbr {
        case 0:
            factTitel.text = "Budget"
            factValue.text = changeToCurrency(number: film.budget)
        case 1:
            factTitel.text = "Revenue"
            factValue.text = changeToCurrency(number: film.revenue ?? 0)
        case 2:
            factTitel.text = "Original Language"
            factValue.text = Locale.current.localizedString(forLanguageCode: film.language)
        case 3:
            factTitel.text = "Rating"
            factValue.text = String(format: "%.2f" , film.rating) + " (" + String(film.reviews) + ")"
        default:
            break
        }
        self.layer.cornerRadius = 12
    }
    
    func changeToCurrency(number: Int) -> String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "$"
        currencyFormatter.maximumFractionDigits = 0
        let string = currencyFormatter.string(from: number as NSNumber) ?? "$ 0"
        return string.replacingOccurrences(of: ",", with: ".")
    }
}
