//
//  MovieNetworkService.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import Foundation

enum FileError: Error {
    case filePathNotFound
    case corruptedFile
}

struct MovieService {
    
    static func loadData(completionHandler: @escaping (Result<[Movie],Error>) -> Void ) {
        
        if let path = Bundle.main.path(forResource: "movies", ofType: "json") {
            
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
               let movies = try? JSONDecoder().decode([Movie].self, from: data) {
                completionHandler(.success(movies))
            } else {
                completionHandler(.failure(FileError.corruptedFile))
            }
        } else {
            completionHandler(.failure(FileError.filePathNotFound))
        }
    }
    
}
