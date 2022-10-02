//
//  FilterlListViewModel.swift
//  MovieApp
//
//  Created by Akshay Naithani on 01/10/22.
//

import Foundation

protocol FilterlListDelegate: AnyObject {
    func reloadData()
}

class FilterlListViewModel {
    
    weak var delegate: FilterlListDelegate?
    
    let title = "Select filter"
    
    var searchTypes: [SearchType] {
        movies == nil ? [] : SearchType.allCases
    }
    
    var movies: [Movie]? = nil {
        didSet {
            delegate?.reloadData()
        }
    }
    
    func loadData() {
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
