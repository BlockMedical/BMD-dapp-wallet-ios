platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

target 'Trust' do
  use_frameworks!

  pod 'BigInt', '~> 3.0'
  pod 'R.swift'
  pod 'JSONRPCKit', '~> 3.0'
  pod 'PromiseKit', '~> 6.0'
  pod 'APIKit'
  pod 'Eureka'
  pod 'MBProgressHUD'
  pod 'StatefulViewController'
  pod 'QRCodeReaderViewController', :git=>'https://github.com/yannickl/QRCodeReaderViewController.git', :branch=>'master'
  pod 'KeychainSwift'
  pod 'SwiftLint'
  pod 'SeedStackViewController'
  pod 'RealmSwift'
  pod 'Moya', '~> 10.0.1'
  pod 'CryptoSwift', '~> 0.10.0'
  pod 'Kingfisher', '~> 4.0'
  pod 'TrustCore', :git=>'https://github.com/TrustWallet/trust-core', :branch=>'master'
  pod 'TrustKeystore', :git=>'https://github.com/TrustWallet/trust-keystore', :branch=>'master'
  # The 0.0.9 podspec requires Git metadata while preparing its nested source.
  # Keep the audited revision as a submodule so modern CocoaPods can reproduce it.
  pod 'TrezorCrypto', :path => 'Vendor/TrezorCrypto'
  pod 'Branch'
  pod 'SAMKeychain'
  pod 'TrustWeb3Provider', :git=>'https://github.com/TrustWallet/trust-web3-provider', :commit=>'f4e0ebb1b8fa4812637babe85ef975d116543dfd'
  pod 'URLNavigator'
  pod 'TrustWalletSDK', :git=>'https://github.com/TrustWallet/TrustSDK-iOS', :branch=>'master'
  pod 'WebViewJavascriptBridge', '~> 6.0'

  target 'TrustTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TrustUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
    if ['JSONRPCKit'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
    if ['TrustKeystore'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
    # if target.name != 'Realm'
    #     target.build_configurations.each do |config|
    #         config.build_settings['MACH_O_TYPE'] = 'staticlib'
    #     end
    # end
  end
end
