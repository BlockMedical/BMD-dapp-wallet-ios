// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

enum NavigateAction {
    case presentAction
    case pushAction
}

final class CustomWebCoordinator: NSObject, Coordinator {
    var coordinators: [Coordinator] = []
    var didCompleted: (() -> Void)?

    let navigationController: NavigationController
    private let action: NavigateAction
    private let url: URL

    private lazy var customWebViewController: CustomWebViewController = {
        let controller = CustomWebViewController(url: url)
        return controller
    }()

    init(navigationController: NavigationController = NavigationController(), navigateAction: NavigateAction, url: URL) {
        self.navigationController = navigationController
        self.action = navigateAction
        self.url = url
    }

    func start() {
        if action == .presentAction {
            customWebViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(completed))
        } else {
            customWebViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(completed))
        }
        navigationController.viewControllers = [customWebViewController]
    }

    @objc func completed() {
        didCompleted?()
    }

}
