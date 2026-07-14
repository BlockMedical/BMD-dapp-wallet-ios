// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import RealmSwift
import TrustCore

struct RealmConfiguration {

    static func sharedConfiguration() -> Realm.Configuration {
        var config = Realm.Configuration()
        let directory = config.fileURL!.deletingLastPathComponent()
        let url = directory.appendingPathComponent("shared.realm")
        return Realm.Configuration(fileURL: url)
    }

    static func configuration(for account: WalletInfo) -> Realm.Configuration {
        var config = Realm.Configuration()
        let directory = config.fileURL!.deletingLastPathComponent()
        let newURL = directory.appendingPathComponent("\(account.description).realm")
        config.fileURL = newURL
        return config
    }
}

enum RealmRecovery {
    static func open(configuration: Realm.Configuration, recoveryKey: String) -> Realm? {
        NSLog("BM-DIAG R1 open %@ key=%@", configuration.fileURL?.lastPathComponent ?? "?", recoveryKey)
        if !UserDefaults.standard.bool(forKey: recoveryKey) {
            NSLog("BM-DIAG R2 first-launch quarantine begins")
            guard quarantineFiles(configuration: configuration) else { return nil }
            UserDefaults.standard.set(true, forKey: recoveryKey)
            NSLog("BM-DIAG R3 first-launch quarantine done")
        }

        do {
            NSLog("BM-DIAG R4 try Realm open...")
            let realm = try Realm(configuration: configuration)
            NSLog("BM-DIAG R5 Realm open OK")
            return realm
        } catch {
            NSLog("BM-DIAG R4x Realm open FAILED: %@", String(describing: error))
            guard quarantineFiles(configuration: configuration) else { return nil }
            let retried = try? Realm(configuration: configuration)
            NSLog("BM-DIAG R6 retry after quarantine: %@", retried == nil ? "FAILED" : "OK")
            return retried
        }
    }

    private static func quarantineFiles(configuration: Realm.Configuration) -> Bool {
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
        let directoryName = "BlockMed-Realm-Recovery-\(formatter.string(from: Date()))-\(UUID().uuidString)"
        let backupDirectory = realmURL.deletingLastPathComponent()
            .appendingPathComponent(directoryName, isDirectory: true)

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
}
