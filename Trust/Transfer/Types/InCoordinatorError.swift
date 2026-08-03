// Copyright DApps Platform Inc. All rights reserved.

import Foundation

enum InCoordinatorError: LocalizedError {
    case onlyWatchAccount
    case databaseRecoveryFailed

    var errorDescription: String? {
        switch self {
        case .onlyWatchAccount:
            return NSLocalizedString(
                "InCoordinatorError.onlyWatchAccount",
                value: "This wallet can be only used for watching. Import Private Key/Keystore to sign transactions/messages",
                comment: ""
            )
        case .databaseRecoveryFailed:
            return "BlockMed could not safely recover this wallet's local database. Your encrypted wallet file was not deleted."
        }
    }
}
