//
//  PersonWrapper.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 01.10.22.
//

import Foundation

struct PersonWrapper: Codable{
    var count: Int
    var next: String?
    var results: [Person]
    var previous: String?
}
