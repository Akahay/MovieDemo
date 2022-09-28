//
//  FilterlListViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

class FilterlListViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    var searchTypes: [SearchType] {
        movies == nil ? [] : SearchType.allCases
    }
    
    var movies: [Movie]? = nil {
        didSet {
            filterTableView.reloadData()
        }
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
        let searchType = searchTypes[indexPath.row]
        switch searchType {
        case .all:
            let vc: MovieListViewController = UIStoryboard.vcInstance()
            vc.viewModel.set(movies: movies ?? [], searchType: searchTypes[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        case .year,.genre,.directors,.actors:
            let vc: ListViewController = UIStoryboard.vcInstance()
            vc.viewModel.set(movies: movies ?? [], searchType: searchType)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}




