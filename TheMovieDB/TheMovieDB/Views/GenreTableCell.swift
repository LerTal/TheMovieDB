//
//  GenreTableCell.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 07/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

protocol GenreTableCellDelegate: class {
    func genreCell(cell: GenreTableCell, filtered: Bool)
    func genreCell(cell: GenreTableCell, highlighted: Bool)
}

class GenreTableCell: UITableViewCell {
    
    // MARK: - Properties
    var genre: Genre? {
        willSet {
            genreLabel.text = newValue?.name
            updateFilterd()
            updateHighlighted()
        }
    }
    weak var delegate: GenreTableCellDelegate?
    
    // MARK: - IBOutlet
    @IBOutlet weak var genreLabel:      UILabel!
    @IBOutlet weak var filterButton:    UIButton!
    @IBOutlet weak var highlightButton: UIButton!
    
    
    // MARK: - View Lifwcycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupButtons()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        genreLabel.text = genre?.name
        updateFilterd()
        updateHighlighted()
    }
    
    // MARK: - setups
    
    fileprivate func setupButtons() {
        filterButton.tintColor = UIColor.systemGray2
        filterButton.setImage(UIImage(systemName: "pin.slash"), for: .normal)
        highlightButton.tintColor = UIColor.systemGray2
        highlightButton.setImage(UIImage(systemName: "pin.slash"), for: .normal)
    }
    
    func updateFilterd() {
        guard let genre = genre else { return }
        
        let imageName = (genre.filtered ? "pin.fill" : "pin.slash")
        filterButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        let imageColor = (genre.filtered ? UIColor.systemBlue : UIColor.systemGray2)
        filterButton.tintColor = imageColor
    }
    
    func updateHighlighted() {
        guard let genre = genre else { return }
        
        let imageName = (genre.highlighted ? "pin.fill" : "pin.slash")
        highlightButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        let imageColor = (genre.highlighted ? UIColor.systemBlue : UIColor.systemGray2)
        highlightButton.tintColor = imageColor
    }
    
    // MARK: - IBAction
    
    @IBAction func filterButtonTap(_ sender: UIButton) {
        if (genre == nil) { return }
        
        genre!.filtered = !(genre!.filtered)
        updateFilterd()
        
        delegate?.genreCell(cell: self, filtered: genre!.filtered)
    }
    
    @IBAction func highlightButtonTap(_ sender: UIButton) {
        if (genre == nil) { return }
        
        genre!.highlighted = !(genre!.highlighted)
        updateHighlighted()
        
        delegate?.genreCell(cell: self, highlighted: genre!.highlighted)
    }
}
