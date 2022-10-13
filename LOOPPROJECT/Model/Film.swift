//
//  Film.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 01.10.22.
//

import Foundation

struct Film: Codable, Equatable{
    static func == (lhs: Film, rhs: Film) -> Bool {
        lhs.title == rhs.title
    }
    
    let rating: Float
    let id: Int
    let revenue: Int?
    let releaseDate: String
    let director: Person
    let posterUrl: String
    let cast: [Person]
    let runtime: Int
    let title: String
    let overview: String
    let reviews: Int
    let budget: Int
    let language: String
    let genres: [String]
    var favorite: Bool?
    var picked: Bool?
}
