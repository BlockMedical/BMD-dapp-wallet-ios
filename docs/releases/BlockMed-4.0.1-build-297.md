# BlockMed iOS 4.0.1 (Build 297) Complete Startup Recovery Release Record

Date: July 13, 2026 (America/Los_Angeles)  
App Store Connect app ID: `1447441652`  
Bundle ID: `ai.blockmed.wallet`

## Evidence-based diagnosis

The owner confirmed an immediate crash on build 296 using an iPhone 12 running iOS 26.5 and submitted TestFlight feedback at 10:42 PM PDT. App Store Connect and Xcode associated the launch failure with `swift_unexpectedError` in `AppDelegate.application(_:didFinishLaunchingWithOptions:)`.

Build 296 quarantined only `shared.realm`. When encrypted wallets remained present, `AppCoordinator` immediately opened the account-specific Realm through a second `try! Realm(configuration:)` in `InCoordinator`. That forced open remained capable of producing the same optimized AppDelegate startup signature. A second forced startup operation existed in `EtherKeystore` as `try! KeyStore(keyDirectory:)`.

## Build 297 correction

- Centralizes guarded Realm opening and timestamped same-volume quarantine.
- Applies first-launch quarantine to every account-specific Realm as well as the shared Realm.
- Replaces the per-wallet forced Realm open with optional guarded recovery and a visible error.
- Makes `EtherKeystore` initialization throwable and catches KeyStore directory failures in AppDelegate.
- Preserves encrypted wallet files in `Documents/keystore` and iOS Keychain passwords.
- Removes every `try!` operation from the application startup call chain.
- Advances Realm schema to 81 and build number to 297.

## Verification before upload

- Production `BlockMed-Prod` Release device build: successful.
- Full `TrustTests` Release device compilation: successful.
- Startup forced-error audit: no remaining `try!` or `fatalError` in the launch path.
- Simulator execution: unavailable because bundled Realm 3.7.6 contains an iOS-device binary and cannot link for iOS Simulator.
- Direct wireless iPhone deployment: unavailable because no paired device was detected.

## Required TestFlight test

Install build 297 over the existing app without deleting it. Confirm prompt interface display, wallet access, background/foreground operation, and two cold launches. Do not attach build 297 to App Review until all checks pass.
