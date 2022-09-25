//
//  UIStoryboard+.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

extension UIStoryboard {
    
    static func vcInstance<T: UIViewController>() -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: T.xibIdentifier) as! T
    }
    
}
