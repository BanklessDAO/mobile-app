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
    // MARK: - Constants -
    
    private static let animationStepDuration: TimeInterval = 0.25
    
    // MARK: - Properties -
    
    private var webViewSizeConstraints = ConstraintGroup()
    private var content: String?
    
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
    
    // MARK: - Lifecycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let content = content {
            webView.loadHTMLString(content, baseURL: nil)
        }
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
        webView.alpha = 0.0
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .backgroundBlack
        webView.isOpaque = false
        webView.navigationDelegate = self
        addSubview(webView)
    }
    
    private func setUpConstraints() {
        constrain(webView, self) { content, view in
            content.left == view.left
            content.right == view.right
            content.top == view.top + contentInsets.top
            content.bottom == view.bottom - contentInsets.bottom
        }
        
        webView.scrollView.rx
            .observe(CGSize.self, #keyPath(UIScrollView.contentSize))
            .map({ return ($0?.height ?? 0) })
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                
                constrain(
                    self.webView, replace: self.webViewSizeConstraints
                ) { content in
                    content.height == height
                }
            })
            .disposed(by: disposer)
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        output.rawMarkup
            .drive(onNext: { [weak self] content in
                self?.content = content
                self?.webView.loadHTMLString(content, baseURL: nil)
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(
            "document.readyState",
            completionHandler: { [weak self] result, error in
                if result == nil || error != nil {
                    return
                }
                
                UIView.animate(
                    withDuration: MarkupView.animationStepDuration,
                    delay: MarkupView.animationStepDuration,
                    options: []
                ) {
                    self?.webView.alpha = 1.0
                }
            }
        )
    }
}
