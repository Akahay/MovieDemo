//
//  ViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainScrollViewBottomConstraint: NSLayoutConstraint!
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    let viewModel = MovieListViewModel()
    var searchType: SearchType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch searchType {
        case .all:
            title = searchType.title
            searchBar.placeholder = "search movies by title/actor/genre/director"
        case .year,.genre,.directors,.actors:
            searchBar.isHidden = true
        }
        movieTableView.register(cellName: MovieDetailsTableViewCell.xibIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(show: false, notification: notification)
    }
    
    private func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        
        guard let value = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height) * (show ? 1 : 0)
        
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.mainScrollViewBottomConstraint.constant = adjustmentHeight
        }, completion: { (completed) in
            if show {
                self.movieTableView.scrollRectToVisible(self.searchBar.frame, animated: true)
            }
        })
    }
}

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.update(text: searchText, searchType: searchType)
        movieTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.update(text: "", searchType: .all)
        movieTableView.reloadData()
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieDetailsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.set(movie: viewModel.movie(index: indexPath.row), imageCache: imageCache)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        let vc: MovieDetailsViewController = UIStoryboard.vcInstance()
        vc.movie = viewModel.movie(index: indexPath.row)
        vc.imageCache = imageCache
        navigationController?.pushViewController(vc, animated: true)
    }
}

class MovieListViewModel {
    
    var movies: [Movie] = [] {
        didSet {
            filteredMovies = movies
        }
    }
    var filteredMovies: [Movie] = []
    
    var numberOfRows: Int {
        filteredMovies.count
    }
    
    func update(text: String, searchType: SearchType) {
        
        let text = text.lowercased()
        
        if text.isEmpty {
            filteredMovies = movies
        } else {
            switch searchType {
            case .all:
                filteredMovies = searchAll(text: text)
            case .year,.genre,.directors,.actors:
                filteredMovies = movies
            }
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
        movies.filter{ $0.year.contains(text) || $0.year.inBetween(value: text) }
    }
    
    private func filterMoviesOnTitle(text: String) -> [Movie] {
        movies.filter{ $0.title.lowercased().contains(text) }
    }
    
    private func filterMoviesOnGenre(text: String) -> [Movie] {
        movies.filter{ $0.genre.lowercased().contains(text) }
    }
    
    private func filterMoviesOnDirectors(text: String) -> [Movie] {
        movies.filter{ $0.directors.lowercased().contains(text) }
    }
    
    private func filterMoviesOnActors(text: String) -> [Movie] {
        movies.filter{ $0.actors.lowercased().contains(text) }
    }
    
    func movie(index: Int) -> Movie {
        filteredMovies[index]
    }
}
