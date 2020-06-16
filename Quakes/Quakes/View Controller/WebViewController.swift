//
//  WebViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/9/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var webView: WKWebView!

    //MARK: - Properties
    var urlString: String?{
        didSet{
            if let urlFormat = urlString {
                let myURL = URL(string: urlFormat)
                url = myURL
            }
        }
    }
    
    var url: URL?
    private var loadSpinner: UIActivityIndicatorView!
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        webView.navigationDelegate = self
    }

    //MARK: - Actions
    @IBAction func openSafaryButtonPressed(_ sender: UIBarButtonItem) {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Private func
    private func setUI() {
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        setUpSpinner()
        
        view = webView
        
        if let url = url{
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
        }
    }
    
    private func setUpSpinner() {
        loadSpinner = UIActivityIndicatorView(style: .large)
        loadSpinner.color = .gray
        loadSpinner.hidesWhenStopped = true
        loadSpinner.center = view.center
        loadSpinner.autoresizingMask = [.flexibleWidth,.flexibleLeftMargin, .flexibleRightMargin]
        webView.addSubview(loadSpinner)
    }
    
}

//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate  {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if isViewLoaded{
            
            loadSpinner.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadSpinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadSpinner.stopAnimating()
        
    }
}
