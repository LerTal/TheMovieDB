//
//  GenresViewController.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var genreTable: UITableView!
    
    
    // MARK: - Properties
    var genresViewModel = GenresViewModel()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        
        genresViewModel.delegate = self
        genresViewModel.start()
    }
    
    // MARK: - Setups
    
    func setupCollection() {
        genreTable.delegate   = self
        genreTable.dataSource = self
    }
    
    
    // MARK: - IBActions
    @IBAction func done(_ sender: Any) {
//        UserDefaults.standard.setFiltered(genres: self.genresViewModel.filterdIds())
//        UserDefaults.standard.setHighlighted(genres: self.genresViewModel.highlightedIds())
        self.genresViewModel.saveGenresInUserDefaults()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate
extension GenresViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension GenresViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresViewModel.cellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreTableCellID", for: indexPath) as! GenreTableCell
        if let genre = genresViewModel.movie(at: indexPath.row) {
            cell.genre = genre
            cell.delegate = self
        }
        return cell
    }
    
}

// MARK: - GenresViewModelDelegate
extension GenresViewController: GenresViewModelDelegate {
    
    func finishedReloadGenres() {
        genreTable.reloadData()
    }
    
}

// MARK: - GenreTableCellDelegate
extension GenresViewController: GenreTableCellDelegate {
    
    func genreCell(cell: GenreTableCell, filtered: Bool) {
        guard let indexPath = self.genreTable.indexPath(for: cell) else { return }
        
        if (indexPath.row == 0) {   // update all cells
            genresViewModel.updateGenres(filtered: filtered)
            self.genreTable.reloadData()
        }
        else {  // update only first cell
            if filtered {
                if (genresViewModel.filterdCount() == genresViewModel.cellCount()-1) {
                    genresViewModel.updateGenres(filtered: filtered, index: 0)
                    self.genreTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }
            else {
                genresViewModel.updateGenres(filtered: filtered, index: 0)
                self.genreTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
    
    func genreCell(cell: GenreTableCell, highlighted: Bool) {
        guard let indexPath = self.genreTable.indexPath(for: cell) else { return }
        
        if (indexPath.row == 0) {   // update all cells
            genresViewModel.updateGenres(highlighted: highlighted)
            self.genreTable.reloadData()
        }
        else {  // update only first cell
            if highlighted {
                if (genresViewModel.highlightedCount() == genresViewModel.cellCount()-1) {
                    genresViewModel.updateGenres(highlighted: highlighted, index: 0)
                    self.genreTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }
            else {
                genresViewModel.updateGenres(highlighted: highlighted, index: 0)
                self.genreTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
    
}
