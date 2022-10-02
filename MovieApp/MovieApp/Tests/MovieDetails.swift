//
//  MovieDetails.swift
//  MovieAppTests
//
//  Created by Akshay Naithani on 01/10/22.
//

import XCTest
@testable import MovieApp

final class MovieDetails: XCTestCase, LoadJsonProtocol {
    let viewModel = MovieDetailsViewModel()
    
    func test_empty_title() {
        XCTAssertNil(viewModel.movie)
        viewModel.setTuples()
        XCTAssertNil(viewModel.standard(ratingValue: ""))
        XCTAssertTrue(viewModel.title.isEmpty)
        XCTAssertTrue(viewModel.info.isEmpty)
        XCTAssertTrue(viewModel.ratingTuples.isEmpty)
        
    }
    
    func test_first_item() {
        if let movie = load().first {
            viewModel.movie = movie
            XCTAssertNotNil(viewModel.movie)
            XCTAssertEqual(viewModel.title, movie.title)
            viewModel.setTuples()
            let tuples: [(String,Double)] = [("Internet Movie Database",70),("Rotten Tomatoes",84.0),("Metacritic",73.0),]
            for index in 0..<tuples.count {
                XCTAssertEqual(tuples[index].0, viewModel.ratingTuples[index].0)
                XCTAssertEqual(tuples[index].1, viewModel.ratingTuples[index].1)
            }
            XCTAssertEqual(viewModel.info, info(movie: movie))
        }
    }
    
    
    
    private func info(movie: Movie?) -> String {
        guard let movie = movie else {
            return ""
        }
        let nL = "\n\n"
        return "\(nL) Title: \(movie.title)\(nL) Year: \(movie.year) \(nL) Released: \(movie.released) \(nL) Rear: \(movie.runtime) \(nL) Genre: \(movie.genre) \(nL) Directors: \(movie.directors) \(nL) Writer: \(movie.writer) \(nL) Actors: \(movie.actors) \(nL) Plot: \(movie.plot) \(nL) Language: \(movie.language) \(nL) Year: \(movie.year)"
    }
}
