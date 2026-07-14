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
        window = UIWindow(frame: UIScreen.main.bounds)

        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        guard let realm = openSharedRealm(configuration: sharedMigration.config) else {
            showStorageRecoveryError()
            return true
        }
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)

        coordinator = AppCoordinator(window: window!, keystore: keystore, navigator: urlNavigatorCoordinator)
        coordinator.start()

        protectionCoordinator.didFinishLaunchingWithOptions()
        urlNavigatorCoordinator.branch.didFinishLaunchingWithOptions(launchOptions: launchOptions)
        return true
    }

    private func openSharedRealm(configuration: Realm.Configuration) -> Realm? {
        let recoveryKey = "BlockMedRealmRecovery296Completed"
        if !UserDefaults.standard.bool(forKey: recoveryKey) {
            guard quarantineRealmFiles(configuration: configuration) else { return nil }
            UserDefaults.standard.set(true, forKey: recoveryKey)
        }

        do {
            return try Realm(configuration: configuration)
        } catch {
            guard quarantineRealmFiles(configuration: configuration) else { return nil }
            return try? Realm(configuration: configuration)
        }
    }

    private func quarantineRealmFiles(configuration: Realm.Configuration) -> Bool {
        guard let realmURL = configuration.fileURL else { return false }

        let fileManager = FileManager.default
        let candidates = [
            realmURL,
            URL(fileURLWithPath: realmURL.path + ".lock"),
            URL(fileURLWithPath: realmURL.path + ".note"),
            URL(fileURLWithPath: realmURL.path + ".management")
        ].filter { fileManager.fileExists(atPath: $0.path) }

        guard !candidates.isEmpty else { return true }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        let backupDirectory = realmURL.deletingLastPathComponent()
            .appendingPathComponent("BlockMed-Realm-Recovery-\(formatter.string(from: Date()))", isDirectory: true)

        do {
            try fileManager.createDirectory(at: backupDirectory, withIntermediateDirectories: true)
            for sourceURL in candidates {
                try fileManager.moveItem(
                    at: sourceURL,
                    to: backupDirectory.appendingPathComponent(sourceURL.lastPathComponent)
                )
            }
            return true
        } catch {
            return false
        }
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
