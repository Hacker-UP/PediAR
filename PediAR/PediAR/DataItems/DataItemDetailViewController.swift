//
//  DataItemDetailViewController.swift
//  PediAR
//
//  Created by Harry Twan on 04/11/2017.
//  Copyright © 2017 宋 奎熹. All rights reserved.
//

import UIKit
import WebKit

class DataItemDetailViewController: UIViewController {

    public var wikiURL = ""
    
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: wikiURL) {
            webView = WKWebView.init(frame: view.bounds)
            let request = URLRequest.init(url: url)
            webView.load(request)
            view.addSubview(webView)
        }
    }
}
