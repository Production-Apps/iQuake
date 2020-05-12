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
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp() {
        guard let url = urlString else {
            return
        }
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
}
