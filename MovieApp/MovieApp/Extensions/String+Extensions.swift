//
//  String.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import Foundation

extension String {
    
    func inBetween(value: String) -> Bool {
        let elements = split(separator: "–")
        if let intValue = Int(value) {
            let integers = elements.compactMap { Int($0) }.sorted()
            if integers.count != 2 {
                return false
            }
            return intValue >= integers[0] && intValue <= integers[1]
        }
        return false
    }
}
