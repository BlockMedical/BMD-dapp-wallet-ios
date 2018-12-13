// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

enum WalletAction {
    case none
    case addToken(Address)
}

enum Tabs {
    case browser(openURL: URL?)
    case registerFile(openURL: URL?)
    case accessFile(openURL: URL?)
    case wallet(WalletAction)
    case settings

    var index: Int {
        switch self {
        case .browser: return 0
        case .registerFile: return 1
        case .accessFile: return 2
        case .wallet: return 3
        case .settings: return 4
        }
    }
}

extension Tabs: Equatable {
    static func == (lhs: Tabs, rhs: Tabs) -> Bool {
        switch (lhs, rhs) {
        case (let .browser(lhs), let .browser(rhs)):
            return lhs == rhs
        case (let .registerFile(lhs), let .registerFile(rhs)):
            return lhs == rhs
        case (let .accessFile(lhs), let .accessFile(rhs)):
            return lhs == rhs
        case (.wallet, .wallet),
             (.settings, .settings):
            return true
        case (_, .browser),
             (_, .registerFile),
             (_, .accessFile),
             (_, .wallet),
             (_, .settings):
            return false
        }
    }
}
