//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!

    var movie: Movie?
    var imageCache: NSCache<AnyObject, AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        var movieImage = UIImage(named: "movie")
        if let cachedImage = imageCache?.object(forKey: movie.poster as AnyObject) as? UIImage {
            movieImage = cachedImage
        }
        
        title = movie.title
        infoLabel.text = getInfo(movie: movie)
        movieImageView.image = movieImage
    }
    
    private func getInfo(movie: Movie) -> String {
        
        var info = "\n\nTitle: \(movie.title) \n\n Year: \(movie.year) \n\n Released: \(movie.released) \n\n Rear: \(movie.runtime) \n\n Genre: \(movie.genre) \n\n Directors: \(movie.directors) \n\n Writer: \(movie.writer) \n\n Actors: \(movie.actors) \n\n Plot: \(movie.plot) \n\n Language: \(movie.language) \n\n Year: \(movie.year)"
        
//        if !movie.ratings.isEmpty {
//            info += "Ratings\n\n"
//            for rating in movie.ratings {
//                info += "\t \(rating.source): \(rating.value) \n\n"
//            }
//        }
        return info
    }
}
