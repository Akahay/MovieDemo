//
//  FilterlListViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

class FilterlListViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    let viewModel = FilterlListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        viewModel.delegate = self
        viewModel.loadData()
    }
}
extension FilterlListViewController: FilterlListDelegate {
    
    func reloadData() {
        filterTableView.reloadData()
    }
}

extension FilterlListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.searchTypes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let searchType = viewModel.searchTypes[indexPath.row]
        let movies = viewModel.movies ?? []
        switch searchType {
        case .all:
            let vc: MovieListViewController = UIStoryboard.vcInstance()
            vc.viewModel.set(movies: movies, searchType: viewModel.searchTypes[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        case .year,.genre,.directors,.actors:
            let vc: ListViewController = UIStoryboard.vcInstance()
            vc.viewModel.set(movies: movies, searchType: searchType)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

