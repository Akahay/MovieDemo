//
//  ViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet private weak var movieTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var mainScrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sequenceControlStackView: UIStackView!
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    let viewModel = MovieListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.searchType == .all {
            title = viewModel.searchType.title
            searchBar.placeholder = "search movies by title/actor/genre/director"
        } else {
            searchBar.isHidden = true
            sequenceControlStackView.isHidden = true
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
    
    @IBAction private func sortByAscendingTitle() {
        viewModel.sortType = .ascending
        movieTableView.reloadData()
    }
    
    @IBAction private func sortByDescendingTitle() {
        viewModel.sortType = .descending
        movieTableView.reloadData()
    }
    
    @IBAction private func sortByYear() {
        viewModel.sortType = .year
        movieTableView.reloadData()
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
        viewModel.update(text: searchText)
        movieTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.update(text: "")
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
    
    enum SortType {
        case ascending
        case descending
        case year
    }
    
    var sortType: SortType = .ascending {
        didSet {
            filterOnLastSelectedSort()
        }
    }
    
    var movies: [Movie] = [] {
        didSet {
            filteredMovies = movies
        }
    }
    
    var searchType: SearchType = .all
    var filteredMovies: [Movie] = []
    
    var numberOfRows: Int {
        filteredMovies.count
    }
    
    func set(movies: [Movie], searchType: SearchType) {
        self.movies = movies
        self.searchType = searchType
    }
    
    func update(text: String) {
        
        let text = text.lowercased()
        
        if text.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = searchAll(text: text)
        }
        filterOnLastSelectedSort()
    }
    
    func movie(index: Int) -> Movie {
        filteredMovies[index]
    }
    
    private func filterOnLastSelectedSort() {
        switch sortType {
        case .ascending:
            sortByTitleAscending()
        case .descending:
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
    
    private func sortByTitleAscending() {
        filteredMovies.sort { $0.title.lowercased() < $1.title.lowercased() }
    }
    
    private func sortByTitleDescending() {
        filteredMovies.sort { $0.title.lowercased() > $1.title.lowercased() }
    }
    
    private func sortByYear() {
        filteredMovies.sort {  Int($0.year.getFirstValidForYear) ?? 0 < Int($1.year.getFirstValidForYear) ?? 0 }
    }
}
