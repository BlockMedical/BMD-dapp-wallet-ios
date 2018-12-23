// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

final class CustomWebCoordinator: NSObject, Coordinator {
    var coordinators: [Coordinator] = []

    private let navigationController: NavigationController
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
        navigationController.present(customWebViewController, animated: true)
    }

}
