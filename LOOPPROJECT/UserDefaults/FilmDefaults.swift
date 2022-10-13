//
//  FilmDefaults.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 10.10.22.
//

import Foundation


struct FilmDefaults {
    
    private init() {}
    
    static func saveFilms(films: [Film], key: String) {
        if let encoded = try? JSONEncoder().encode(films) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func loadFilms(key: String) -> [Film]{
        if let data = UserDefaults.standard.data(forKey: key) {
            if let decoded = try? JSONDecoder().decode([Film].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    static func updateFilms(with film: Film,key: String, favorite: Bool) {
        
        var allFilms = self.loadFilms(key: key)
        for i in 0..<allFilms.count {
            if allFilms[i].title == film.title {
                allFilms[i].favorite = favorite
            }
        }
        saveFilms(films: allFilms, key: key)
    }
}
