//
//  FilmLoader.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 01.10.22.
//

import Foundation

public class FilmLoader{
    
    var filmData = [Film]()
    
    init(ressource: String){
        load(ressource: ressource)
        setFavorites()
        setPicked()
    }
    
    func load(ressource: String){
        if let fileLocation = Bundle.main.url(forResource: ressource, withExtension: "json"){
            
            do{
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Film].self, from: data)
                self.filmData = dataFromJson
                
            } catch {
                print(error)
            }
        }
        
    }
    
    func setFavorites(){
       filmData = filmData.map({ film in
            var movie = film
           movie.favorite = film.favorite ?? false
            return movie
        })
    }
    func setPicked(){
       filmData = filmData.map({ film in
            var movie = film
           movie.picked = film.picked ?? false
            return movie
        })
    }
    
}
