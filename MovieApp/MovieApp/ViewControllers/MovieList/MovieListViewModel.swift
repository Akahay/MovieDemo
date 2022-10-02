//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Akshay Naithani on 01/10/22.
//

import Foundation

class MovieListViewModel {
    
    enum SortType {
        case titleAscending
        case titleDescending
        case year
    }
    
    let searchbarPlaceholder = "search movies by title/actor/genre/director"
    var searchType: SearchType = .all
    var filteredMovies: [Movie] = []
    
    var sortType: SortType = .titleAscending {
        didSet {
            filterOnLastSelectedSort()
        }
    }
    
    var movies: [Movie] = [] {
        didSet {
            filteredMovies = movies
        }
    }
    
    
    var numberOfRows: Int {
        filteredMovies.count
    }
    
    func set(movies: [Movie], searchType: SearchType) {
        self.movies = movies
        self.searchType = searchType
    }
    
    func update(text: String) {
        let lowercasedText = text.lowercased()
        filteredMovies = lowercasedText.isEmpty ? movies : searchAll(text: lowercasedText)
        filterOnLastSelectedSort()
    }
    
    func movie(index: Int) -> Movie {
        filteredMovies[index]
    }
    
    private func filterOnLastSelectedSort() {
        switch sortType {
        case .titleAscending:
            sortByTitleAscending()
        case .titleDescending:
            sortByTitleDescending()
        case .year:
            sortByYear()
        }
        
    }
    
    private func searchAll(text: String) -> [Movie] {
        var results = filterMoviesOnYear(text: text)
        results.append(contentsOf: filterMoviesOnGenre(text: text))
        results.append(contentsOf: filterMoviesOnTitle(text: text))
        results.append(contentsOf: filterMoviesOnDirectors(text: text))
        results.append(contentsOf: filterMoviesOnActors(text: text))
        return Array(Set(results))
    }
    
    private func filterMoviesOnYear(text: String) -> [Movie] {
        movies.filter { $0.year.contains(text) || $0.year.inBetween(value: text) }
    }
    
    private func filterMoviesOnTitle(text: String) -> [Movie] {
        movies.filter { $0.title.lowercased().contains(text) }
    }
    
    private func filterMoviesOnGenre(text: String) -> [Movie] {
        movies.filter { $0.genre.lowercased().contains(text) }
    }
    
    private func filterMoviesOnDirectors(text: String) -> [Movie] {
        movies.filter { $0.directors.lowercased().contains(text) }
    }
    
    private func filterMoviesOnActors(text: String) -> [Movie] {
        movies.filter { $0.actors.lowercased().contains(text) }
    }
    
    private func sortByTitleAscending() {
        filteredMovies.sort { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    private func sortByTitleDescending() {
        filteredMovies.sort { $0.title.lowercased() > $1.title.lowercased() }
    }
    
    private func sortByYear() {
        filteredMovies.sort { Int($0.year.getFirstValidForYear) ?? 0 < Int($1.year.getFirstValidForYear) ?? 0 }
    }
}
