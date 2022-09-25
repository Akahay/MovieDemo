//
//  MovieDetailsTableViewCell.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    func set(movie: Movie, imageCache: NSCache<AnyObject, AnyObject>) {
        
        titleLabel.text = movie.title
        languageLabel.text = "Language: \(movie.language)"
        yearLabel.text = "Year: \(movie.year)"
        if let cachedImage = imageCache.object(forKey: movie.poster as AnyObject) as? UIImage {
            profileImageView.image = cachedImage
        } else {
            profileImageView.image = UIImage(named: "movie")
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageURL = URL(string: movie.poster),
                   let imagedata = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imagedata) {
                    imageCache.setObject(image, forKey: movie.poster as AnyObject)
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {
                            return
                        }
                        self.profileImageView.image = image
                    }
                }
            }
        }
        
    }
}
