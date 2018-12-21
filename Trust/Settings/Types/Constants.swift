// Copyright DApps Platform Inc. All rights reserved.

import Foundation

public struct Constants {
    public static let keychainKeyPrefix = "trustwallet"
    public static let keychainTestsKeyPrefix = "trustwallet-tests"

    // social
    public static let website = "https://trustwalletapp.com"
    public static let twitterUsername = "trustwalletapp"
    public static let blockMedTwitterUsername = "BlockMed_AI"
    public static let defaultTelegramUsername = "trustwallet"
    public static let defaultBlockMedTelegramUsername = "blockmed"
    public static let facebookUsername = "trustwalletapp"

    public static var localizedTelegramUsernames = ["ru": "trustwallet_ru", "vi": "trustwallet_vn", "es": "trustwallet_es", "zh": "trustwallet_cn", "ja": "trustwallet_jp", "de": "trustwallet_de", "fr": "trustwallet_fr"]

    // support
    public static let supportEmail = "support@trustwalletapp.com"
    public static let blockMedSupportEmail = "info@blockmed.ai"

    public static let dappsBrowserURL = "http://www.blockmed.ai"
    public static let dappsRegisterFileURL = BlockMedConstants.blockMedBaseURL + "file-register"
    public static let dappsAccessFileURL = BlockMedConstants.blockMedBaseURL + "file-access"
    public static let dappsOpenSea = "https://opensea.io"
    public static let dappsRinkebyOpenSea = "https://rinkeby.opensea.io"

    public static let images = "https://trustwalletapp.com/images"

    public static let trustAPI = URL(string: "https://public.trustwalletapp.com")!
}

public struct BlockMedConstants {
    // BlockMed
    #if DEBUG
    public static let blockMedBaseURL = "https://ipfs-dev.blcksync.info/"
    #elseif BETA
    public static let blockMedBaseURL = "https://ipfs-dev.blcksync.info/"
    #else
    public static let blockMedBaseURL = "https://ipfs.blcksync.info/"
    #endif
}

public struct UnitConfiguration {
    public static let gasPriceUnit: EthereumUnit = .gwei
    public static let gasFeeUnit: EthereumUnit = .ether
}

public struct URLSchemes {
    public static let trust = "app://"
    public static let browser = trust + "browser"
}
