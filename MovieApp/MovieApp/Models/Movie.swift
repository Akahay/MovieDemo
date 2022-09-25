//
//  Movie.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import Foundation
import UIKit

struct Movie: Decodable {
    
    let title: String
    let year: String
    let released: String
    let runtime: String
    let genre: String
    let directors: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let poster: String
    let ratings: [Rating]
    let uuid: String
    
    enum CodingKeys: String, CodingKey {
        case title      = "Title"
        case year       = "Year"
        case released   = "Released"
        case runtime    = "Runtime"
        case genre      = "Genre"
        case directors   = "Director"
        case writer     = "Writer"
        case actors     = "Actors"
        case plot       = "Plot"
        case language   = "Language"
        case poster     = "Poster"
        case ratings    = "Ratings"
    }
    
    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        title           = try container.decode(String.self, forKey: .title)
        year            = try container.decodeIfPresent(String.self, forKey: .year) ?? ""
        released        = try container.decodeIfPresent(String.self, forKey: .released) ?? ""
        runtime         = try container.decodeIfPresent(String.self, forKey: .runtime) ?? ""
        genre           = try container.decodeIfPresent(String.self, forKey: .genre) ?? ""
        directors       = try container.decodeIfPresent(String.self, forKey: .directors) ?? ""
        writer          = try container.decodeIfPresent(String.self, forKey: .writer) ?? ""
        actors          = try container.decodeIfPresent(String.self, forKey: .actors) ?? ""
        plot            = try container.decodeIfPresent(String.self, forKey: .plot) ?? ""
        language        = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        poster          = try container.decodeIfPresent(String.self, forKey: .poster) ?? ""
        ratings         = try container.decodeIfPresent([Rating].self, forKey: .ratings) ?? []
        uuid            = UUID().uuidString
    }
    
}

extension Movie: Equatable, Hashable {
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
