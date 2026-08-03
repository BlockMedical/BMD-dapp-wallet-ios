// Copyright DApps Platform Inc. All rights reserved.

import Foundation

final class DeviceChecker: JailbreakChecker {
    func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else

        let list: [String] = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
        ]

        return !list.filter { FileManager.default.fileExists(atPath: $0) }.isEmpty
        #endif
    }
}
