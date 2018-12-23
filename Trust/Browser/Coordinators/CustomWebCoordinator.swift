// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

final class CustomWebCoordinator: NSObject, Coordinator {
    var coordinators: [Coordinator] = []
    var didCompleted: (() -> Void)?

    let navigationController: NavigationController
    private let url: URL

    private lazy var customWebViewController: CustomWebViewController = {
        let controller = CustomWebViewController(url: url)
        return controller
    }()

    init(navigationController: NavigationController = NavigationController(), url: URL) {
        self.navigationController = navigationController
        self.url = url
    }

    func start() {
        customWebViewController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Dismiss", style: .done, target: self, action: #selector(dismiss))
        navigationController.viewControllers = [customWebViewController]
    }

    @objc func dismiss() {
        didCompleted?()
    }

}
