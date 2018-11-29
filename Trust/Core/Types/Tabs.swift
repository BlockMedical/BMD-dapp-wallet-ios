// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

enum WalletAction {
    case none
    case addToken(Address)
}

enum Tabs {
    case browser(openURL: URL?)
    case mobileApp(openURL: URL?)
    case wallet(WalletAction)
    case settings

    var index: Int {
        switch self {
        case .browser: return 0
        case .mobileApp: return 1
        case .wallet: return 2
        case .settings: return 3
        }
    }
}

extension Tabs: Equatable {
    static func == (lhs: Tabs, rhs: Tabs) -> Bool {
        switch (lhs, rhs) {
        case (let .browser(lhs), let .browser(rhs)):
            return lhs == rhs
        case (let .mobileApp(lhs), let .mobileApp(rhs)):
            return lhs == rhs
        case (.wallet, .wallet),
             (.settings, .settings):
            return true
        case (_, .browser),
             (_, .mobileApp),
             (_, .wallet),
             (_, .settings):
            return false
        }
    }
}
