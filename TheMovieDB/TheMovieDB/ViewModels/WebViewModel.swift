//
//  WebViewModel.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 07/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import Foundation


protocol WebViewModelDelegate: class {
    func aaaaa()
}

class WebViewModel {
    
    var video: Video?
    weak var delegate: WebViewModelDelegate?
    
    init(video: Video) {
        self.video = video
    }
}


