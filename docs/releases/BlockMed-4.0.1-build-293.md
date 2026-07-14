# BlockMed iOS 4.0.1 (Build 293) Crash-Fix Release Record

Date: July 13, 2026 (America/Los_Angeles)  
App Store Connect app ID: `1447441652`  
Bundle ID: `ai.blockmed.wallet`  
Apple team: `AYN7MX9997`

## Outcome

Build 293 replaces crash-affected build 292. It retains the BlockMed display name, BlockMed executable, production bundle ID, and restored blue mesh icon while restoring the internal Swift module name to `Trust` for database compatibility. Xcode archived, signed, validated, and uploaded the build successfully. App Store Connect reported that the uploaded package is processing.

The final App Review submission remains a manual owner action after TestFlight confirms that build 293 opens correctly on the affected iPhone.

## Crash evidence and root cause

App Store Connect supplied five TestFlight crash logs from build 292 on an iPhone 12 running iOS 26.5. Each log terminated on the main thread at:

`AppDelegate.application(_:didFinishLaunchingWithOptions:)`, `AppDelegate.swift:21`

The stack contained `swift_unexpectedError` immediately above the forced Realm open (`try! Realm(...)`). Build 291's compiled types were module-qualified as `Trust.*`, while build 292's compiled types were qualified as `BlockMed.*`. Realm persists those qualified names. Because the product rename silently changed the Swift module identity without a corresponding data migration, build 292 could not open the existing `shared.realm` database and the forced `try!` terminated the app.

This diagnosis was verified directly from the archived binaries:

- Build 291: `Trust.WalletInfoViewController`, `Trust.CoinTicker`, and other `Trust.*` symbols.
- Build 292: corresponding `BlockMed.*` symbols.
- Build 293: corresponding `Trust.*` symbols again, while `CFBundleDisplayName` and `CFBundleExecutable` remain `BlockMed`.

## Source correction

The production and development app target configurations now explicitly set:

`PRODUCT_MODULE_NAME = Trust`

The user-visible product names remain `BlockMed` and `BlockMed-Dev`. The release build number was increased from 292 to 293. No Realm files are deleted, renamed, or reset; the correction intentionally preserves existing wallet metadata.

## Verification

- Release archive: `build/BlockMed-4.0.1-293-signed.xcarchive`
- Scheme: `BlockMed-Prod`
- Version/build: `4.0.1 (293)`
- Architecture: `arm64`
- Minimum iOS: `16.0`
- Bundle: `ai.blockmed.wallet`
- Display name/executable: `BlockMed`
- Swift module: `Trust`
- Signing identity: Apple Development, Wayne Chung
- Provisioning profile: `iOS Team Provisioning Profile: ai.blockmed.wallet`
- Code signature verification: valid and satisfies its designated requirement
- Export method: `app-store-connect`, automatic signing, upload destination
- Apple upload result: `Upload succeeded` and `EXPORT SUCCEEDED` at approximately 9:01 PM PDT on July 13, 2026

The legacy Realm dependency is device-only, so the iOS simulator cannot reproduce this device database path. The affected iPhone does not need a cable: install build 293 from TestFlight after Apple finishes processing it, open it over the air, and confirm that the existing wallet view loads without a crash.

## App Store completion checklist

1. Wait for build 293 to finish processing in App Store Connect.
2. Add build 293 to the internal TestFlight group if Apple does not carry the assignment forward automatically.
3. On the affected iPhone, refresh TestFlight, install build 293, and launch BlockMed without deleting the existing app first. Testing as an in-place update is necessary to exercise the preserved Realm database.
4. Confirm launch, wallet list display, background/foreground behavior, and a second cold launch.
5. Remove build 292 from the 4.0.1 App Review submission if it is still attached, attach build 293, save, and review the submission summary.
6. The owner performs the final App Review submission manually.

Do not delete the app before the TestFlight check: deletion would remove the existing Realm data and would not validate the upgrade-path fix.
