// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import Branch
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator!
    //This is separate coordinator for the protection of the sensitive information.
    lazy var protectionCoordinator: ProtectionCoordinator = {
        return ProtectionCoordinator()
    }()
    let urlNavigatorCoordinator = URLNavigatorCoordinator()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NSLog("BM-DIAG A1 didFinishLaunching start")
        window = UIWindow(frame: UIScreen.main.bounds)

        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        NSLog("BM-DIAG A2 shared migration config ready")
        // Build 298: Realm files written by Realm 3.x (2018) fault with
        // EXC_BAD_ACCESS after Realm 20's in-place format upgrade, so a new
        // recovery generation quarantines every legacy file once and starts
        // fresh. Wallet keys live in Documents/keystore + Keychain, not Realm.
        guard let realm = RealmRecovery.open(
            configuration: sharedMigration.config,
            recoveryKey: "BlockMedRealmRecovery298.shared.realm"
        ) else {
            NSLog("BM-DIAG A2x shared realm recovery FAILED")
            showStorageRecoveryError()
            return true
        }
        NSLog("BM-DIAG A3 shared realm open")
        let walletStorage = WalletStorage(realm: realm)
        guard let keystore = try? EtherKeystore(storage: walletStorage) else {
            NSLog("BM-DIAG A3x keystore init FAILED")
            showStorageRecoveryError()
            return true
        }
        NSLog("BM-DIAG A4 keystore ready")

        coordinator = AppCoordinator(window: window!, keystore: keystore, navigator: urlNavigatorCoordinator)
        NSLog("BM-DIAG A5 AppCoordinator init done")
        coordinator.start()
        NSLog("BM-DIAG A6 AppCoordinator started")

        protectionCoordinator.didFinishLaunchingWithOptions()
        urlNavigatorCoordinator.branch.didFinishLaunchingWithOptions(launchOptions: launchOptions)
        NSLog("BM-DIAG A7 didFinishLaunching end")
        return true
    }

    private func showStorageRecoveryError() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "BlockMed could not safely recover its local database. Your wallet files were not deleted. Please contact BlockMed support."
        viewController.view.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -24),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        coordinator.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        protectionCoordinator.applicationWillResignActive()
        Lock().setAutoLockTime()
        CookiesStore.save()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        protectionCoordinator.applicationDidBecomeActive()
        CookiesStore.load()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        protectionCoordinator.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        protectionCoordinator.applicationWillEnterForeground()
    }

    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplicationExtensionPointIdentifier.keyboard {
            return false
        }
        return true
    }

//    func application(
//        _ application: UIApplication,
//        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        Branch.getInstance().handlePushNotification(userInfo)
//    }

    // Respond to URI scheme links
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return urlNavigatorCoordinator.application(app, open: url, options: options)
    }

    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        Branch.getInstance().continue(userActivity)
        return true
    }
}
