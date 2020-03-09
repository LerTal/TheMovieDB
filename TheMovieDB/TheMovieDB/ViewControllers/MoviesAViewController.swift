//
//  MoviesAViewController.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

class MoviesAViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var collection: UICollectionView!
    
    // MARK: - Properties
    var moviesAViewModel = MoviesAViewModel()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        
        moviesAViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (moviesAViewModel.resetScrollToStart) {
            //collection.setContentOffset(.zero, animated: true)
            collection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: false)
        }
        moviesAViewModel.start()
        self.title = moviesAViewModel.titleForVC
    }
    
    // MARK: - Setups
    
    func setupCollection() {
        collection.delegate   = self
        collection.dataSource = self
    }
    
}


// MARK: - UICollectionViewDelegate
extension MoviesAViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(identifier: "DetailsViewControllerID") as! DetailsViewController
        if let movie = moviesAViewModel.movie(at: indexPath.row) {
            detailsVC.detailsViewModel = DetailsViewModel(movie: movie)
        }
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension MoviesAViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesAViewModel.cellCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
        if let movie = moviesAViewModel.movie(at: indexPath.row) {
            cell.setup(with: movie)
        }
//        cell.backgroundColor = .brown  // debug only
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesAViewController: UICollectionViewDelegateFlowLayout {
    
    var padding: CGFloat { return 5 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = 3
        let paddingSpace = padding * CGFloat(itemsPerRow + 1)
        let availableWidth = collection.frame.size.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: (1.7 * widthPerItem))
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
}

// MARK: - MoviesAViewModelDelegate
extension MoviesAViewController: MoviesAViewModelDelegate {
    
    func finishedReloadMovies() {
        collection.reloadData()
    }
    
}
