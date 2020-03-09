//
//  YouTubeVideoPlayerVC.swift
//  TheMovieDB
//
//  Created by Tal Lerman on 06/03/2020.
//  Copyright © 2020 Tal Lerman. All rights reserved.
//

import UIKit
import WebKit

// ---------------------------------------------------------------------
// https://gist.github.com/starhoshi/efde2a0283f05e6a4d32a225617294ab
// ---------------------------------------------------------------------


// class YouTubeVideoPlayerVC


class WebViewController: UIViewController {
//    var url: URL! = URL(string: "https://www.youtube.com/embed/F6QaLsw8EWY")!
    var wKWebView: WKWebView!
    var webViewModel: WebViewModel?
    
    // MARK: - IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var goBackButton: UIBarButtonItem?
    @IBOutlet weak var goForwardButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        wKWebView = WKWebView(frame: createWKWebViewFrame(size: view.frame.size))
        containerView.addSubview(wKWebView)
        wKWebView.navigationDelegate = self
        wKWebView.uiDelegate = self
        
        guard let url = webViewModel?.video?.url else { return }
        let request = URLRequest(url: url)
        wKWebView.load(request)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        wKWebView.frame = createWKWebViewFrame(size: size)
    }

    @IBAction func onTappedGoBack(_ sender: Any) {
        wKWebView.goBack()
    }

    @IBAction func onTappedGoForward(_ sender: Any) {
        wKWebView.goForward()
    }
}

extension WebViewController {
    fileprivate func createWKWebViewFrame(size: CGSize) -> CGRect {
        let navigationHeight: CGFloat = 60
        let toolbarHeight: CGFloat = 44
        let height = size.height - navigationHeight - toolbarHeight
        return CGRect(x: 0, y: 0, width: size.width, height: height)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // show indicator
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // dismiss indicator
      
        // if url is not valid {
        //    decisionHandler(.cancel)
        // }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // dismiss indicator
      
        goBackButton?.isEnabled = webView.canGoBack
        goForwardButton?.isEnabled = webView.canGoForward
        navigationItem.title = webView.title
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      // show error dialog
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

