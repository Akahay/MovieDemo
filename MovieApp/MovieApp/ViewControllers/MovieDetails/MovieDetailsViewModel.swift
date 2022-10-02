//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Akshay Naithani on 01/10/22.
//

import Foundation

class MovieDetailsViewModel {
    
    var movie: Movie?
    var ratingTuples: [(String,Double)] = []
    
    var title: String {
        return movie?.title ?? ""
    }
    
    var info: String {
        guard let movie = movie else {
            return ""
        }
        let nL = "\n\n"
        return "\(nL) Title: \(movie.title)\(nL) Year: \(movie.year) \(nL) Released: \(movie.released) \(nL) Rear: \(movie.runtime) \(nL) Genre: \(movie.genre) \(nL) Directors: \(movie.directors) \(nL) Writer: \(movie.writer) \(nL) Actors: \(movie.actors) \(nL) Plot: \(movie.plot) \(nL) Language: \(movie.language) \(nL) Year: \(movie.year)"
    }
    
    func setTuples() {
        movie?.ratings.forEach { rating in
            if let standard = standard(ratingValue: rating.value) {
                ratingTuples.append((rating.source,standard))
            }
        }
    }
    
    func standard(ratingValue: String) -> Double? {
        let percentChar: Character = "%"
        let slashChar: Character = "/"
         if ratingValue.contains(percentChar),
            let ratingValue = ratingValue.split(separator: percentChar).first,
            let ratingDoubleValue = Double(ratingValue) {
             return ratingDoubleValue
         } else if ratingValue.contains(slashChar) {
             let items = ratingValue.split(separator: slashChar)
             if let firstValue = items.first,
                let lastValue = items.last,
                let firstValue = Double(firstValue),
                let lastValue = Double(lastValue),
                lastValue > 0,
                firstValue >= 0 {
                 return (firstValue / lastValue) * 100
             }
         }
        return nil
    }
}
