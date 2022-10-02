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
            searchBar.placeholder = viewModel.searchbarPlaceholder
        } else {
            searchBar.isHidden = true
            sequenceControlStackView.isHidden = true
        }
        movieTableView.register(cellNames: [MovieListViewCell.xibIdentifier])
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
        viewModel.sortType = .titleAscending
        movieTableView.reloadData()
    }
    
    @IBAction private func sortByDescendingTitle() {
        viewModel.sortType = .titleDescending
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
        
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.mainScrollViewBottomConstraint.constant = adjustmentHeight
        } completion: { (completed) in
            if show {
                self.movieTableView.scrollRectToVisible(self.searchBar.frame, animated: true)
            }
        }
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
        let cell: MovieListViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.set(movie: viewModel.movie(index: indexPath.row), imageCache: imageCache)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        let vc: MovieDetailsViewController = UIStoryboard.vcInstance()
        vc.viewModel.movie = viewModel.movie(index: indexPath.row)
        vc.imageCache = imageCache
        navigationController?.pushViewController(vc, animated: true)
    }
}
