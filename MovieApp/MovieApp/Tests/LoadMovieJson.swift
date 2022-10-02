//
//  LoadMovieJson.swift
//  MovieAppTests
//
//  Created by Akshay Naithani on 02/10/22.
//

import XCTest
@testable import MovieApp

protocol LoadJsonProtocol: AnyObject {
    func load() -> [Movie]
}
extension LoadJsonProtocol {
    
    func load() -> [Movie] {
        if let file = Bundle(for: type(of: self)).url(forResource: "Movie-Tests", withExtension: "json"),
           let data = try? Data(contentsOf: file),
           let movies = try? JSONDecoder().decode([Movie].self, from: data) {
           return movies
        }
        return []
    }
}
