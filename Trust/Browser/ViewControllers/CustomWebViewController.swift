// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import WebKit

class CustomWebViewController: UIViewController {

    private lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        return configuration
    }()

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.navigationDelegate = self
        webView.isUserInteractionEnabled = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.hidesWhenStopped = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()

    // MARK: - Lifecycle

    deinit {
    }

    init(url: URL) {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(indicatorView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        webView.load(URLRequest(url: url))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension CustomWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.stopAnimating()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorView.startAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView didFail : \(error)")
        indicatorView.stopAnimating()
    }

}
