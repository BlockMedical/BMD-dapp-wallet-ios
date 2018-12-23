// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import WebKit
import JavaScriptCore
import Result
import WebViewJavascriptBridge

enum BrowserAction {
    case history
    case addBookmark(bookmark: Bookmark)
    case bookmarks
    case qrCode
    case changeURL(URL)
    case navigationAction(BrowserNavigation)
}

protocol BrowserViewControllerDelegate: class {
    func didCall(action: DappAction, callbackID: Int)
    func runAction(action: BrowserAction)
    func didVisitURL(url: URL, title: String)
    func shouldOpenCustomWeb(url: URL)
}

final class BrowserViewController: UIViewController {

    private var myContext = 0
    let type: BrowserType
    let account: WalletInfo
    let sessionConfig: Config

    private struct Keys {
        static let estimatedProgress = "estimatedProgress"
        static let developerExtrasEnabled = "developerExtrasEnabled"
        static let URL = "URL"
        static let ClientName = "Trust"
    }

    private lazy var userClient: String = {
        return Keys.ClientName + "/" + (Bundle.main.versionNumber ?? "")
    }()

    lazy var webView: WKWebView = {
        let webView = WKWebView(
            frame: .zero,
            configuration: self.config
        )
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        if isDebug {
            webView.configuration.preferences.setValue(true, forKey: Keys.developerExtrasEnabled)
        }
        return webView
    }()

    private var bridge = WebViewJavascriptBridge()
    private var jsBridgeHandler = [String: [String: String]]()

    lazy var errorView: BrowserErrorView = {
        let errorView = BrowserErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.delegate = self
        return errorView
    }()

    weak var delegate: BrowserViewControllerDelegate?

    var browserNavBar: BrowserNavigationBar? {
        return navigationController?.navigationBar as? BrowserNavigationBar
    }

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = Colors.darkBlue
        progressView.trackTintColor = .clear
        return progressView
    }()

    //Take a look at this issue : https://stackoverflow.com/questions/26383031/wkwebview-causes-my-view-controller-to-leak
    lazy var config: WKWebViewConfiguration = {
        //TODO
        let config = WKWebViewConfiguration.make(for: server, address: account.address, with: sessionConfig, in: ScriptMessageProxy(delegate: self))
        config.websiteDataStore = WKWebsiteDataStore.default()
        return config
    }()

    let server: RPCServer

    init(
        type: BrowserType,
        account: WalletInfo,
        config: Config,
        server: RPCServer
    ) {
        self.type = type
        self.account = account
        self.sessionConfig = config
        self.server = server

        super.init(nibName: nil, bundle: nil)

        view.addSubview(webView)
        injectUserAgent()

        webView.addSubview(progressView)
        webView.bringSubview(toFront: progressView)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),

            progressView.topAnchor.constraint(equalTo: view.layoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),

            errorView.topAnchor.constraint(equalTo: webView.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: webView.bottomAnchor),
        ])
        view.backgroundColor = .white
        webView.addObserver(self, forKeyPath: Keys.estimatedProgress, options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: Keys.URL, options: [.new, .initial], context: &myContext)

        setupWebViewJavascriptBridge()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        browserNavBar?.browserDelegate = self
        refreshURL()
    }

    private func injectUserAgent() {
        webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
            guard let `self` = self, let currentUserAgent = result as? String else { return }
            self.webView.customUserAgent = currentUserAgent + " " + self.userClient
        }
    }

    func goTo(url: URL) {
        webView.load(URLRequest(url: url))
    }

    func notifyFinish(callbackID: Int, value: Result<DappCallback, DAppError>) {
        let script: String = {
            switch value {
            case .success(let result):
                return "executeCallback(\(callbackID), null, \"\(result.value.object)\")"
            case .failure(let error):
                return "executeCallback(\(callbackID), \"\(error)\", null)"
            }
        }()
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

    func goHome() {
        var homeURL = ""
        switch type {
        case .blockMed:
            homeURL = Constants.dappsBrowserURL
        case .registerFile:
            homeURL = Constants.dappsRegisterFileURL
        case .accessFile:
            homeURL = Constants.dappsAccessFileURL
        }

        guard let url = URL(string: homeURL) else { return }
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        hideErrorView()
        webView.load(request)
        browserNavBar?.textField.text = url.absoluteString
    }

    func reload() {
        hideErrorView()
        webView.reload()
    }

    private func stopLoading() {
        webView.stopLoading()
    }

    private func refreshURL() {
        browserNavBar?.textField.text = webView.url?.absoluteString
        browserNavBar?.backButton.isHidden = !webView.canGoBack

    }

    private func recordURL() {
        guard let url = webView.url else {
            return
        }
        delegate?.didVisitURL(url: url, title: webView.title ?? "")
    }

    private func changeURL(_ url: URL) {
        delegate?.runAction(action: .changeURL(url))
        refreshURL()
    }

    private func hideErrorView() {
        errorView.isHidden = true
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        if context != &myContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == Keys.estimatedProgress {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress
                progressView.isHidden = progress == 1
            }
        } else if keyPath == Keys.URL {
            if let url = webView.url {
                self.browserNavBar?.textField.text = url.absoluteString
                changeURL(url)
            }
        }
    }

    deinit {
        webView.removeObserver(self, forKeyPath: Keys.estimatedProgress)
        webView.removeObserver(self, forKeyPath: Keys.URL)
        NotificationCenter.default.removeObserver(self)
    }

    func addBookmark() {
        guard let url = webView.url?.absoluteString else { return }
        guard let title = webView.title else { return }
        delegate?.runAction(action: .addBookmark(bookmark: Bookmark(url: url, title: title)))
    }

    @objc private func showBookmarks() {
        delegate?.runAction(action: .bookmarks)
    }

    @objc private func history() {
        delegate?.runAction(action: .history)
    }

    func handleError(error: Error) {
        if error.code == NSURLErrorCancelled {
            return
        } else {
            if error.domain == NSURLErrorDomain,
                let failedURL = (error as NSError).userInfo[NSURLErrorFailingURLErrorKey] as? URL {
                changeURL(failedURL)
            }
            errorView.show(error: error)
        }
    }

    // MARK: - Private Methods

    private func setupWebViewJavascriptBridge() {
        WebViewJavascriptBridge.enableLogging()
        self.bridge = WebViewJavascriptBridge(webView)
        self.bridge.setWebViewDelegate(self)

        // File List Item
        self.bridge.registerHandler("FileListItemAccessButtonDidTap") { (data, callback) in
            setJsBridgeHandlerEvent(data: data)

            if let callback = callback {
                callback("FileListItemAccessButtonDidTap callback")
            }
        }

        self.bridge.registerHandler("FileListItemDownloadFileButtonDidTap") { [unowned self] (data, callback) in
            if let urlString = data as? String, let url = URL(string: urlString) {
                self.delegate?.shouldOpenCustomWeb(url: url)
            }

            if let callback = callback {
                callback("FileListItemDownloadFileButtonDidTap callback")
            }
        }

        // File Register
        self.bridge.registerHandler("FileRegisterButtonDidTap") { (data, callback) in
            setJsBridgeHandlerEvent(data: data)

            if let callback = callback {
                callback("FileRegisterButtonDidTap callback")
            }
        }

        func setJsBridgeHandlerEvent(data: Any?) {
            if let data = data as? [String: [String: String]],
                let key = data.keys.first,
                let value = data[key],
                jsBridgeHandler[key] == nil {
                jsBridgeHandler[key] = value
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(BrowserViewController.transactionConfirmed), name: Notification.Name(rawValue: "transactionConfirmed"), object: nil)
    }
}

extension BrowserViewController: BrowserNavigationBarDelegate {
    func did(action: BrowserNavigation) {
        delegate?.runAction(action: .navigationAction(action))
        switch action {
        case .goBack:
            break
        case .more:
            break
        case .home:
            break
        case .enter:
            break
        case .beginEditing:
            stopLoading()
        }
    }
}

extension BrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        recordURL()
        hideErrorView()
        refreshURL()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        hideErrorView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }
}

extension BrowserViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let command = DappAction.fromMessage(message) else { return }
        let requester = DAppRequester(title: webView.title, url: webView.url)
        //TODO: Refactor
        let token = TokensDataStore.token(for: server)
        let transfer = Transfer(server: server, type: .dapp(token, requester))
        let action = DappAction.fromCommand(command, transfer: transfer)

        delegate?.didCall(action: action, callbackID: command.id)
    }
}

extension BrowserViewController: BrowserErrorViewDelegate {
    func didTapReload(_ sender: Button) {
        reload()
    }
}

extension BrowserViewController {

    @objc func transactionConfirmed(note: Notification) {
        // TODO: should fix twice notifications
        if let txID = note.object as? String, !txID.isEmpty, jsBridgeHandler[txID] != nil,
            let value = jsBridgeHandler[txID],
            let type = value["type"] {
            var eventKey = ""
            var params = ["": ""]
            switch type {
            case "accessFile":
                eventKey = "FileListItemFetchKeyForIPFS-" + "\(value["hashId"] ?? "")"
                params = ["ipfsMetadataHash": txID]
            case "registerFile":
                eventKey = "FileRegisterCompleted"
                params = ["ipfsMetadataHash": txID]
            default:
                break
            }
            jsBridgeHandler.removeValue(forKey: txID)
            bridge.callHandler(eventKey, data: params, responseCallback: { (response) in
                if let response = response {
                    print("### callHandler response : \(response)")
                }
            })
        }
    }

}
