//
//  SearchType.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import Foundation

enum SearchType: String, CaseIterable {
    case all
    case year
    case genre
    case directors
    case actors
    
    var title: String {
        return rawValue.capitalized
    }
}
