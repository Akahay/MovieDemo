//
//  GenreListViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit


class ListViewController: UIViewController {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    var viewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
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
