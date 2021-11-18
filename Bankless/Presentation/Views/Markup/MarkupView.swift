//
//  Created with ♥ by BanklessDAO contributors on 2021-11-17.
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
import Cartography
import RxSwift
import RxCocoa
import Kingfisher
import WebKit

class MarkupView: BaseView<MarkupViewModel> {
    // MARK: - Properties -
    
    private var webViewSizeConstraints = ConstraintGroup()
    
    // MARK: - Subviews -
    
    private var webView: WKWebView!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        let config = WKWebViewConfiguration()
        
        if #available(iOS 13.0, *) {
            let pref = WKWebpagePreferences.init()
            pref.preferredContentMode = .mobile
            config.defaultWebpagePreferences = pref
        }
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .backgroundBlack
        webView.isOpaque = false
        addSubview(webView)
    }
    
    private func setUpConstraints() {
        constrain(webView, self) { content, view in
            content.left == view.left
            content.right == view.right
            content.top == view.top + contentInsets.top
            content.bottom == view.bottom - contentInsets.bottom
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        output.rawMarkup
            .drive(onNext: { [weak self] content in
                self?.webView.loadHTMLString(content, baseURL: nil)
                self?.webView.navigationDelegate = self
            })
            .disposed(by: disposer)
    }
    
    private func input() -> MarkupViewModel.Input {
        return .init()
    }
}

extension MarkupView: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url,
            navigationAction.navigationType == .linkActivated,
            UIApplication.shared.canOpenURL(url)
        {
            decisionHandler(.cancel)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        webView.evaluateJavaScript(
            "document.readyState",
            completionHandler: { [weak self] result, error in
                if result == nil || error != nil {
                    return
                }
                
                self?.webView.evaluateJavaScript(
                    "document.body.offsetHeight",
                    completionHandler: { result, error in
                        guard let self = self else { return }
                        
                        if result == nil || error != nil {
                            return
                        }
                        
                        if let height = result as? CGFloat {
                            constrain(
                                self.webView, replace: self.webViewSizeConstraints
                            ) { content in
                                content.height == height
                            }
                        }
                    }
                )
            }
        )
    }
}
