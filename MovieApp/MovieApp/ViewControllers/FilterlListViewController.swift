//
//  FilterlListViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

struct GenreDataSource {
    var genres: [String] = []
    var genreToMoviesMap: [String: [Movie]] = [:]
}

class FilterlListViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    var genreDataSource = GenreDataSource()
    var searchTypes: [SearchType] {
        movies == nil ? [] : SearchType.allCases
    }
    
    var movies: [Movie]? = nil {
        didSet {
            curateGenreDataSource(movies: movies ?? [])
            filterTableView.reloadData()
        }
    }
    
    func curateGenreDataSource(movies: [Movie]) {
        
        var uniqueGenres: [String] = []
        var genreToMoviesMap: [String: [Movie]] = [:]
        for movie in movies {
            let currentGenres = movie.genre.split(separator: ",")
            for genre in currentGenres {
                let validGenre = genre.trimmingCharacters(in: .whitespaces)
                if !uniqueGenres.contains(String(validGenre)) {
                    uniqueGenres.append(validGenre)
                }
                if var moviesCovered = genreToMoviesMap[validGenre] {
                    moviesCovered.append(movie)
                    genreToMoviesMap[validGenre] = moviesCovered
                } else {
                    genreToMoviesMap[validGenre] = [movie]
                }
            }
        }
        genreDataSource = GenreDataSource(genres: uniqueGenres, genreToMoviesMap: genreToMoviesMap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select filter"
        MovieService.loadData {[weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension FilterlListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchTypes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if searchTypes[indexPath.row] == .genre {
            let vc: GenreListViewController = UIStoryboard.vcInstance()
            vc.genreDataSource = genreDataSource
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc: MovieListViewController = UIStoryboard.vcInstance()
            vc.viewModel.movies = movies ?? []
            vc.searchType = searchTypes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}




