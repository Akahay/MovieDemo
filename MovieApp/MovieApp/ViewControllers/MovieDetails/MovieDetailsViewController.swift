//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Akshay Naithani on 24/09/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    var viewModel = MovieDetailsViewModel()
    var imageCache: NSCache<AnyObject, AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard viewModel.movie != nil else {
            navigationController?.popViewController(animated: true)
            return
        }
        title = viewModel.title
        viewModel.setTuples()
        mainTableView.register(cellNames: [MovieDetailsViewCell.xibIdentifier, RatingViewCell.xibIdentifier])
    }
}
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.ratingTuples.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: MovieDetailsViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = viewModel.info
            var movieImage = UIImage(named: "movie")
            if let cachedImage = imageCache?.object(forKey: viewModel.movie?.poster as AnyObject) as? UIImage {
                movieImage = cachedImage
            }
            cell.mainImageView.image = movieImage
            return cell
        } else {
            let cell: RatingViewCell = tableView.dequeueReusableCell(for: indexPath)
            let tuple = viewModel.ratingTuples[indexPath.row]
            cell.titleLabel.text = tuple.0
            cell.percentageLabel.text = "\(Int(tuple.1.rounded())) %"
            _ = cell.percentageConstant?.setMultiplier(multiplier: tuple.1/100)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Ratings"
    }
}
