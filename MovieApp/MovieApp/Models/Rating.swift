//
//  Rating.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import Foundation

struct Rating: Decodable {
    let source: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case source     = "Source"
        case value      = "Value"
    }
    
    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        source          = try container.decode(String.self, forKey: .source)
        value           = try container.decode(String.self, forKey: .value)
    }
}
