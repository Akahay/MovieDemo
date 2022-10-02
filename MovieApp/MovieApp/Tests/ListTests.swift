//
//  ListTests.swift
//  MovieAppTests
//
//  Created by Akshay Naithani on 01/10/22.
//

import XCTest
@testable import MovieApp

final class ListTests: XCTestCase, LoadJsonProtocol {
    
    let viewModel = ListViewModel()
    
    func test_empty() {
        XCTAssertTrue(viewModel.dataSource.keys.isEmpty)
        XCTAssertTrue(viewModel.dataSource.keyToMoviesMap.isEmpty)
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertEqual(viewModel.searchType, .genre)
        XCTAssertEqual(viewModel.numberOfRows, 0)
    }
    
    private func update(keys: inout [String], keyToMoviesMap: inout [String: [Movie]], key: String, movie: Movie) {
        if !keys.contains(key) {
            keys.append(key)
        }
        if var moviesCovered = keyToMoviesMap[key] {
            moviesCovered.append(movie)
            keyToMoviesMap[key] = moviesCovered
        } else {
            keyToMoviesMap[key] = [movie]
        }
    }
    
    private func curateGenreDataSource(movies: [Movie]) -> ListViewModel.DataSource {
        var keys: [String] = []
        var keyToMoviesMap: [String: [Movie]] = [:]
        for movie in movies {
            let currentGenres = movie.genre.split(separator: ",")
            for genre in currentGenres {
                let validGenre = genre.trimmingCharacters(in: .whitespaces)
                update(keys: &keys, keyToMoviesMap: &keyToMoviesMap, key: String(validGenre), movie: movie)
            }
        }
        keys = keys.sorted()
        return .init(keys: keys, keyToMoviesMap: keyToMoviesMap)
    }
    
    private func curateActorDataSource(movies: [Movie]) -> ListViewModel.DataSource {
        var keys: [String] = []
        var keyToMoviesMap: [String: [Movie]] = [:]
        for movie in movies {
            let actors = movie.actors.split(separator: ",")
            for _actor in actors {
                update(keys: &keys, keyToMoviesMap: &keyToMoviesMap, key: _actor.trimmingCharacters(in: .whitespaces), movie: movie)
            }
        }
        keys = keys.sorted()
        return .init(keys: keys, keyToMoviesMap: keyToMoviesMap)
    }
    
    private func curateYearDataSource(movies: [Movie]) -> ListViewModel.DataSource {
        var keys: [String] = []
        var keyToMoviesMap: [String: [Movie]] = [:]
        for movie in movies {
            let years = movie.year.split(separator: "–")
            if years.count > 1 {
                if let fromValue = Int(years[0]),
                   let toValue = Int(years[1]) {
                    for val in fromValue...toValue {
                        update(keys: &keys, keyToMoviesMap: &keyToMoviesMap, key: "\(val)", movie: movie)
                    }
                }
            } else if let val = years.first {
                update(keys: &keys, keyToMoviesMap: &keyToMoviesMap, key: "\(val)", movie: movie)
            }
        }
        keys = keys.sorted()
        return .init(keys: keys, keyToMoviesMap: keyToMoviesMap)
    }
    
    private func curateDirectorDataSource(movies: [Movie]) -> ListViewModel.DataSource {
        var keys: [String] = []
        var keyToMoviesMap: [String: [Movie]] = [:]
        for movie in movies {
            let directors = movie.directors.split(separator: ",")
            for director in directors {
                update(keys: &keys, keyToMoviesMap: &keyToMoviesMap, key: director.trimmingCharacters(in: .whitespaces), movie: movie)
            }
        }
        keys = keys.sorted()
        return .init(keys: keys, keyToMoviesMap: keyToMoviesMap)
    }
    
    private func test_datasource(searchType: SearchType) {
        let movies = load()
        var expectedDataSource: ListViewModel.DataSource?
        viewModel.searchType = searchType
        switch searchType {
        case .all:
            break
        case .year:
            expectedDataSource = curateYearDataSource(movies: movies)
            XCTAssertEqual(viewModel.searchType.title,"Year")
        case .genre:
            expectedDataSource = curateGenreDataSource(movies: movies)
            XCTAssertEqual(viewModel.searchType.title,"Genre")
        case .directors:
            expectedDataSource = curateDirectorDataSource(movies: movies)
            XCTAssertEqual(viewModel.searchType.title,"Directors")
        case .actors:
            expectedDataSource = curateActorDataSource(movies: movies)
            XCTAssertEqual(viewModel.searchType.title,"Actors")
        }
        if let expectedDataSource = expectedDataSource {
            viewModel.set(movies: movies, searchType: searchType)
            for index in 0..<viewModel.numberOfRows {
                let key = viewModel.dataSource.keys[index]
                let expectedKey = expectedDataSource.keys[index]
                XCTAssertEqual(key, expectedKey)
                let movies = viewModel.dataSource.keyToMoviesMap[key]
                let expectedMovies = expectedDataSource.keyToMoviesMap[key]
                XCTAssertEqual(movies?.count, expectedMovies?.count)
                if let movies = movies,
                   let expectedMovies = expectedMovies {
                    for index in 0..<movies.count {
                        XCTAssertEqual(movies[index], expectedMovies[index])
                    }
                }
            }
        }
    }
    
    func test_datasource_year() {
        test_datasource(searchType: .year)
    }
    
    func test_datasource_genre() {
        test_datasource(searchType: .genre)
    }
    
    func test_datasource_directors() {
        test_datasource(searchType: .directors)
    }
    
    func test_datasource_actors() {
        test_datasource(searchType: .actors)
    }
    
    func test_cellTitle() {
        let movies = load()
        viewModel.set(movies: movies, searchType: .genre)
        XCTAssertEqual(viewModel.cellTitle(index: 0), "Action(6)")
    }
}
