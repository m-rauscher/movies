//
//  FilmWrapper.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 01.10.22.
//

import Foundation

public class FilmLoader{
    
    var filmData = [Film]()
    
    init() {
        load()
    }
    
    func load(){
        if let fileLocation = Bundle.main.url(forResource: "movies", withExtension: "json"){
            
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
    
}
