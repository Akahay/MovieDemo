//
//  GenreListViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

class GenreListViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var genreDataSource = GenreDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.reloadData()
    }
}

extension GenreListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        genreDataSource.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let filter = genreDataSource.genres[indexPath.row]
        let count = genreDataSource.genreToMoviesMap[filter]?.count ?? 0
        cell.textLabel?.text = filter + "(\(count))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: MovieListViewController = UIStoryboard.vcInstance()
        let filter = genreDataSource.genres[indexPath.row]
        let movies = genreDataSource.genreToMoviesMap[filter]
        vc.viewModel.movies = movies ?? []
        vc.searchType = .genre
        vc.title = filter
        navigationController?.pushViewController(vc, animated: true)
    }
}
