//
//  DetailsViewController.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView:           UIImageView!
    @IBOutlet weak var titleLabel:          UILabel!
    @IBOutlet weak var overviewTextView:    UITextView!
    @IBOutlet weak var separatorA:          UIView!
    @IBOutlet weak var trailersLabel:       UILabel!
    @IBOutlet weak var trailersCollection:  UICollectionView!
    @IBOutlet weak var separatorB:          UIView!
    @IBOutlet weak var informationLabel:    UILabel!
    @IBOutlet weak var informationTextView: UITextView!
    
    // MARK: - Properties
    var detailsViewModel: DetailsViewModel?
    
 
    // MARK: - ViewController Lifecycle   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        setupImageView()
        setupHiddenViews()  // TODO: maybe later adding this ability of showing few trailers (not only one when tapping on main image)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setups
    
    fileprivate func setupImageView() {
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupHiddenViews() {
        separatorA.isHidden = true
        trailersLabel.isHidden = true
        trailersCollection.isHidden = true
        separatorB.isHidden = true
    }
    
    // MARK: - ...
    
    func updateView() {
        
        detailsViewModel?.movie?.backdropImage(completion: { (result) in
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error)
            }
        })
        
        if let title = detailsViewModel?.movie?.title {
            titleLabel?.text = title
        }
        if let overview = detailsViewModel?.movie?.overview {
            overviewTextView?.text = overview
        }
//        if let aaa = newValue?.movie?.originalTitle {
//            trailersCollection?.text = aaa
//        }
        if let bbb = detailsViewModel?.information() {
            informationTextView?.text = bbb
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        let youTubeVideoPlayerVC = storyboard?.instantiateViewController(identifier: "WebViewControllerID") as! WebViewController
        
        if let video = detailsViewModel?.videos?.results.first {
            let webViewModel = WebViewModel(video: video)
            youTubeVideoPlayerVC.webViewModel = webViewModel
            navigationController?.present(youTubeVideoPlayerVC, animated: true, completion: nil)
        }
    }
}


