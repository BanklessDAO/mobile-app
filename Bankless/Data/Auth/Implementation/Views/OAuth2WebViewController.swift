//
//  Created with ♥ by BanklessDAO contributors on 2021-11-05.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Foundation
import UIKit
import OAuthSwift
import WebKit

final class OAuth2WebViewController: OAuthWebViewController {
    // MARK: - Properties -
    
    var targetURL: URL?
    
    // MARK: - Subviews -
    
    let webView: WKWebView = WKWebView()
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.frame = self.view.bounds
        self.webView.navigationDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.webView)
        
        self.view
            .addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "|-0-[view]-0-|",
                    options: [],
                    metrics: nil,
                    views: ["view":self.webView]
                )
            )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: ["view":self.webView]
            )
        )
        
        loadAddressURL()
    }
    
    // MARK: - Redirect handling -
    
    override func handle(_ url: URL) {
        targetURL = url
        super.handle(url)
        self.loadAddressURL()
    }
    
    func loadAddressURL() {
        guard let url = targetURL else {
            return
        }
        
        let req = URLRequest(url: url)
        DispatchQueue.main.async {
            self.webView.load(req)
        }
    }
}

// MARK: - Navigation delegate -

extension OAuth2WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        
        if let url = navigationAction.request.url ,
            url.host == "bankless.community" {
            
            handleRedirect(url: url)
            decisionHandler(.cancel)
            
            self.dismissWebViewController()
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        print("Auth web navigation error: \(error)")
        self.dismissWebViewController()
    }
    
    func handleRedirect(url: URL) {
        if (url.host == "bankless.community") {
            OAuthSwift.handle(url: url)
        }
    }
}
