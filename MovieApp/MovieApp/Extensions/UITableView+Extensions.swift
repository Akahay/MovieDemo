//
//  UITableView.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

extension UITableView {
    
    func register(cellName: String) {
        register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.xibIdentifier, for: indexPath) as! T
    }
}
