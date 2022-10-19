//
//  NetworkManager.swift
//  Movies
//
//  Created by Moritz Rauscher on 19.10.22.
//

import Foundation

enum NetworkError: Error {
    case badResponse(URLResponse?)
    case badStatusCode(Int)
    case badLocalUrl
}


class NetworkManager{
    static var shared = NetworkManager()    
    private var images = NSCache<NSString, NSData>()
    
    let session: URLSession
    
    init() {
      let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func downloadImage(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        //trying to use cached Image
        if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
            completion(imageData as Data, nil)
            return
        }
      
      let task = session.downloadTask(with: imageURL) { localUrl, response, error in
        if let error = error {
            DispatchQueue.main.async {
              completion(nil, error)
            }
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            DispatchQueue.main.async {
                completion(nil, NetworkError.badResponse(response))
            }
            return
        }
        
        guard let localUrl = localUrl else {
            DispatchQueue.main.async {
              completion(nil, NetworkError.badLocalUrl)
            }
            return
        }
        
        do {
            let data = try Data(contentsOf: localUrl)
            DispatchQueue.main.async {
                self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(data, nil)
            }
        } catch let error {
            DispatchQueue.main.async {
              completion(nil, error)
            }
        }
      }
      task.resume()
    }
}
