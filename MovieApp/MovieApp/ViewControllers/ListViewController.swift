//
//  GenreListViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit


class ListViewController: UIViewController {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    var viewModel = GenreListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.vcTitle
        viewModel.makeDataSource()
        mainTableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.cellTitle(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: MovieListViewController = UIStoryboard.vcInstance()
        vc.title = viewModel.movieTitle(index: indexPath.row)
        vc.viewModel.set(movies: viewModel.moviesFor(index: indexPath.row), searchType: viewModel.searchType)
        navigationController?.pushViewController(vc, animated: true)
    }
}

class GenreListViewModel {
    
    struct DataSource {
        var keys: [String] = []
        var keyToMoviesMap: [String: [Movie]] = [:]
    }
    
    var dataSource = DataSource()
    var movies: [Movie] = []
    var searchType: SearchType = .all
    
    func set(movies: [Movie], searchType: SearchType) {
        self.movies = movies
        self.searchType = searchType
    }
    
    var vcTitle: String {
        searchType.title
    }
    
    var numberOfRows: Int {
        dataSource.keys.count
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
    
    func makeDataSource() {
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
