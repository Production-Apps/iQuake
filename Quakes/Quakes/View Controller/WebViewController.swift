//
//  WebViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/9/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    
    @IBOutlet var webView: WKWebView!
    
    var urlString: String?{
        didSet{
            if let urlFormat = urlString {
                let myURL = URL(string: urlFormat)
                url = myURL
            }
        }
    }
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    
    @IBAction func openSafaryButtonPressed(_ sender: UIBarButtonItem) {
        if let url = url {
           UIApplication.shared.open(url)
        }
    }
    
 
    
    func setUp() {
        if let url = url{
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
        }
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
}
