//
//  ListViewModel.swift
//  MovieApp
//
//  Created by Akshay Naithani on 01/10/22.
//

import Foundation

class ListViewModel {
    
    struct DataSource {
        var keys: [String] = []
        var keyToMoviesMap: [String: [Movie]] = [:]
    }
    
    var dataSource = DataSource()
    var movies: [Movie] = []
    var searchType: SearchType = .genre
    var title: String { searchType.title }
    var numberOfRows: Int { dataSource.keys.count }
    
    func set(movies: [Movie], searchType: SearchType) {
        self.movies = movies
        self.searchType = searchType
        self.makeDataSource()
    }
    
    func moviesFor(index: Int) -> [Movie] {
        dataSource.keyToMoviesMap[movieTitle(index: index)] ?? []
    }
    
    func cellTitle(index: Int) -> String {
        movieTitle(index: index) + "(" + movieCount(index: index) + ")"
    }
    
    func movieTitle(index: Int) -> String {
        dataSource.keys[index]
    }
    
    private func movieCount(index: Int) -> String {
        "\(moviesFor(index: index).count)"
    }
    
    private func makeDataSource() {
        if searchType == .genre {
            dataSource = curateGenreDataSource(movies: movies)
        } else if searchType == .year {
            dataSource = curateYearDataSource(movies: movies)
        } else if searchType == .directors {
            dataSource = curateDirectorDataSource(movies: movies)
        } else if searchType == .actors {
            dataSource = curateActorDataSource(movies: movies)
        }
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
    
    private func curateGenreDataSource(movies: [Movie]) -> DataSource {
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
        return DataSource(keys: keys, keyToMoviesMap: keyToMoviesMap)
    }
    
    private func curateYearDataSource(movies: [Movie]) -> DataSource {
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
        return DataSource(keys: keys, keyToMoviesMap: keyToMoviesMap)
    }
    
    private func curateDirectorDataSource(movies: [Movie]) -> DataSource {
        var keys: [String] = []
        var keyToMoviesMap: [String: [Movie]] = [:]
        for movie in movies {
            let directors = movie.directors.split(separator: ",")
            for director in directors {
                update(keys: &keys, keyToMoviesMap: &keyToMoviesMap, key: director.trimmingCharacters(in: .whitespaces), movie: movie)
            }
        }
        keys = keys.sorted()
        return DataSource(keys: keys, keyToMoviesMap: keyToMoviesMap)
    }
    
    private func curateActorDataSource(movies: [Movie]) -> DataSource {
        var keys: [String] = []
        var keyToMoviesMap: [String: [Movie]] = [:]
        for movie in movies {
            let actors = movie.actors.split(separator: ",")
            for _actor in actors {
                update(keys: &keys, keyToMoviesMap: &keyToMoviesMap, key: _actor.trimmingCharacters(in: .whitespaces), movie: movie)
            }
        }
        keys = keys.sorted()
        return DataSource(keys: keys, keyToMoviesMap: keyToMoviesMap)
    }
}
