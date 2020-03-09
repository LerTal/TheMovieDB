//
//  MoviesBViewController.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

class MoviesBViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var table:            UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    // MARK: - Properties
    var moviesBViewModel = MoviesBViewModel()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupSegmentedControl()
        
        moviesBViewModel.delegate = self
        moviesBViewModel.start(filterType: filterType())
    }
    
    // MARK: - Setups
    
    func setupTable() {
        table.delegate   = self
        table.dataSource = self
    }
    
    func setupSegmentedControl() {
        //...
    }
    
    // MARK: - IBActions
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        moviesBViewModel.start(filterType: filterType())
    }
    
    // MARK: - ...
    
    func filterType() -> FilterType {
        let filterType: FilterType
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            filterType = .popular
        default:
            filterType = .rating
        }
        return filterType
    }
    
}

// MARK: - UITableViewDelegate
extension MoviesBViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let detailsVC = storyboard?.instantiateViewController(identifier: "DetailsViewControllerID") as! DetailsViewController
        if let movie = moviesBViewModel.movie(filterType: filterType(), at: indexPath.row) {
                   detailsVC.detailsViewModel = DetailsViewModel(movie: movie)
               }
               navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension MoviesBViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesBViewModel.cellCount(filterType: filterType())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCellID", for: indexPath) as! MovieTableCell
        if let movie = moviesBViewModel.movie(filterType: filterType(), at: indexPath.row) {
            cell.setup(with: movie)
        }
//        cell.backgroundColor = .cyan
        cell.cellIndex = indexPath.row + 1
        return cell
    }
    
}


// MARK: - MoviesBViewModelDelegate
extension MoviesBViewController: MoviesBViewModelDelegate {
    
    func finishedReloadMovies() {
        table.reloadData()
    }
    
}
