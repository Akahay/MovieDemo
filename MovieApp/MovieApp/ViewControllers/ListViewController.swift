//
//  GenreListViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

struct DataSource {
    var keys: [String] = []
    var keyToMoviesMap: [String: [Movie]] = [:]
}

class ListViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    let viewModel = GenreListViewModel()
    var movies: [Movie] = []
    var searchType: SearchType = .all
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = searchType.title
        if searchType == .genre {
            dataSource = viewModel.curateGenreDataSource(movies: movies)
        } else if searchType == .year {
            dataSource = viewModel.curateYearDataSource(movies: movies)
        } else if searchType == .directors {
            dataSource = viewModel.curateDirectorDataSource(movies: movies)
        } else if searchType == .actors {
            dataSource = viewModel.curateActorDataSource(movies: movies)
        }
        mainTableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let filter = dataSource.keys[indexPath.row]
        let count = dataSource.keyToMoviesMap[filter]?.count ?? 0
        cell.textLabel?.text = filter + "(\(count))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: MovieListViewController = UIStoryboard.vcInstance()
        let filter = dataSource.keys[indexPath.row]
        let movies = dataSource.keyToMoviesMap[filter]
        vc.viewModel.movies = movies ?? []
        vc.searchType = .genre
        vc.title = filter
        navigationController?.pushViewController(vc, animated: true)
    }
}

struct GenreListViewModel {
    
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
    
    func curateGenreDataSource(movies: [Movie]) -> DataSource {
        
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
    
    func curateYearDataSource(movies: [Movie]) -> DataSource {
        
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
    
    func curateDirectorDataSource(movies: [Movie]) -> DataSource {
        
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
    
    func curateActorDataSource(movies: [Movie]) -> DataSource {
        
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
