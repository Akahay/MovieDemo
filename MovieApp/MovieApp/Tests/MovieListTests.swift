//
//  MovieListTests.swift
//  MovieAppTests
//
//  Created by Akshay Naithani on 01/10/22.
//

import XCTest
@testable import MovieApp

final class MovieListTests: XCTestCase, LoadJsonProtocol {
    
    let viewModel = MovieListViewModel()
    
    func test_searchbarPlaceholder() {
        XCTAssertEqual(viewModel.searchbarPlaceholder, "search movies by title/actor/genre/director")
    }
    
    func test_default() {
        XCTAssertEqual(viewModel.searchType, .all)
        XCTAssertTrue(viewModel.filteredMovies.isEmpty)
    }
    
    //MARK: Test sorting
    func test_movies_sort_ascending() {
        viewModel.set(movies: load(), searchType: .all)
        XCTAssertEqual(viewModel.searchType, .all)
        let nameAscendingItems = viewModel.filteredMovies.sorted { $0.title.lowercased() < $1.title.lowercased() }
        viewModel.sortType = .titleAscending
        XCTAssertEqual(viewModel.numberOfRows, 19)
        
        for index in 0..<viewModel.numberOfRows {
            XCTAssertEqual(viewModel.movie(index: index), nameAscendingItems[index])
        }
    }
    
    func test_movies_sort_descending() {
        viewModel.set(movies: load(), searchType: .all)
        XCTAssertEqual(viewModel.searchType, .all)
        let nameDescendingItems = viewModel.filteredMovies.sorted { $0.title.lowercased() > $1.title.lowercased() }
        viewModel.sortType = .titleDescending
        XCTAssertEqual(viewModel.numberOfRows, 19)
        XCTAssertEqual(viewModel.sortType, .titleDescending)
        
        for index in 0..<viewModel.numberOfRows {
            XCTAssertEqual(viewModel.movie(index: index), nameDescendingItems[index])
        }
    }
    
    func test_movies_sort_year() {
        viewModel.set(movies: load(), searchType: .all)
        XCTAssertEqual(viewModel.searchType, .all)
        
        let sortedByYear = viewModel.filteredMovies.sorted { Int($0.year.getFirstValidForYear) ?? 0 < Int($1.year.getFirstValidForYear) ?? 0 }
        viewModel.sortType = .year
        XCTAssertEqual(viewModel.numberOfRows, 19)
        XCTAssertEqual(viewModel.sortType, .year)
        
        for index in 0..<viewModel.numberOfRows {
            XCTAssertEqual(viewModel.movie(index: index), sortedByYear[index])
        }
    }
    
    //MARK: Test Search
    func test_empty_search() {
        viewModel.set(movies: load(), searchType: .all)
        XCTAssertEqual(viewModel.searchType, .all)
        viewModel.update(text: "")
        let nameAscendingItems = viewModel.filteredMovies.sorted { $0.title.lowercased() < $1.title.lowercased() }
        viewModel.sortType = .titleAscending
        for index in 0..<viewModel.numberOfRows {
            XCTAssertEqual(viewModel.movie(index: index), nameAscendingItems[index])
        }
    }
    
    func test_substring_search_actor_name() {
        viewModel.set(movies: load(), searchType: .all)
        XCTAssertEqual(viewModel.searchType, .all)
        viewModel.update(text: "Saif")
        XCTAssertEqual(viewModel.filteredMovies.count,1)
        if let movie = viewModel.filteredMovies.first {
            XCTAssertEqual(movie.title,"Race")
        }
    }
    
    func test_substring_search_year() {
        viewModel.set(movies: load(), searchType: .all)
        XCTAssertEqual(viewModel.searchType, .all)
        viewModel.update(text: "2012")
        XCTAssertEqual(viewModel.filteredMovies.count,1)
        if let movie = viewModel.filteredMovies.first {
            XCTAssertEqual(movie.title,"No Limit")
        }
    }
    
    func test_substring_search_genre() {
        viewModel.set(movies: load(), searchType: .all)
        XCTAssertEqual(viewModel.searchType, .all)
        viewModel.update(text: "Comedy")
        XCTAssertEqual(viewModel.filteredMovies.count,6)
    }

}
