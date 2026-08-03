// Copyright DApps Platform Inc. All rights reserved.

import Foundation

public struct Constants {
    public static let keychainKeyPrefix = "ai.blockmed.wallet"
    public static let keychainTestsKeyPrefix = "ai.blockmed.wallet-tests"

    // social
    public static let website = "https://blockmed.ai"
    public static let twitterUsername = "blockmedai"
    public static let blockMedTwitterUsername = "blockmedai"
    public static let defaultTelegramUsername = "blockmedai"
    public static let defaultBlockMedTelegramUsername = "blockmedai"
    public static let facebookUsername = "blockmedai"

    public static var localizedTelegramUsernames = ["ru": "trustwallet_ru", "vi": "trustwallet_vn", "es": "trustwallet_es", "zh": "trustwallet_cn", "ja": "trustwallet_jp", "de": "trustwallet_de", "fr": "trustwallet_fr"]

    // support
    public static let supportEmail = "support@blockmed.ai"
    public static let blockMedSupportEmail = "support@blockmed.ai"

    public static let dappsBrowserURL = "https://blockmed.ai"
    public static let dappsRegisterFileURL = BlockMedConstants.blockMedBaseURL + "file-register"
    public static let dappsAccessFileURL = BlockMedConstants.blockMedBaseURL + "file-access"
    public static let dappsOpenSea = "https://opensea.io"
    public static let dappsRinkebyOpenSea = "https://rinkeby.opensea.io"

    public static let images = "https://blockmed.ai/images"

    public static let trustAPI = URL(string: "https://api.blockmed.ai")!
}

public struct BlockMedConstants {
    // BlockMed
    public static let blockMedBaseURL = "https://ipfs.blockmed.me/"
}

public struct UnitConfiguration {
    public static let gasPriceUnit: EthereumUnit = .gwei
    public static let gasFeeUnit: EthereumUnit = .ether
}

public struct URLSchemes {
    public static let trust = "app://"
    public static let browser = trust + "browser"
}
