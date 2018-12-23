// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class CustomWebViewController: UIViewController {

    // MARK: - Lifecycle

    deinit {
    }

    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
