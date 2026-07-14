# BlockMed iOS 4.0.1 (Build 293) Crash-Fix Release Record

Date: July 13, 2026 (America/Los_Angeles)  
App Store Connect app ID: `1447441652`  
Bundle ID: `ai.blockmed.wallet`  
Apple team: `AYN7MX9997`

## Outcome

Build 293 replaces crash-affected build 292. It retains the BlockMed display name, BlockMed executable, production bundle ID, and restored blue mesh icon while restoring the internal Swift module name to `Trust` for database compatibility. Xcode archived, signed, validated, and uploaded the build successfully. Apple finished processing the build, and the owner manually submitted version 4.0.1 build 293 to App Review.

App Review submission completed, but the owner subsequently confirmed that build 293 also crashes immediately on the affected iPhone 12 running iOS 26.5. Two build 293 TestFlight feedback entries appeared in App Store Connect under the same startup crash signature. Build 293 must not be released; build 294 supersedes it.

## App Store Connect replacement completed

At approximately 9:13 PM PDT on July 13, 2026, the crash-affected build 292 submission was canceled and Apple marked the old submission `Removed`. Version 4.0.1 was unlocked, build 292 was detached, and build 293 was attached. The reviewer notes were updated to identify build 293 and explain the data-compatible Realm/module correction.

Build 293 was the sole item in the new App Review draft. App Store Connect showed version 4.0.1 as `Ready for Review`, the draft as `Ready for Review`, and the item as `4.0.1 (293)`. The owner then manually selected `Submit for Review` and reported that the submission completed.

## Crash evidence and revised diagnosis

App Store Connect supplied five TestFlight crash logs from build 292 on an iPhone 12 running iOS 26.5. Each log terminated on the main thread at:

`AppDelegate.application(_:didFinishLaunchingWithOptions:)`, `AppDelegate.swift:21`

The stack contained `swift_unexpectedError` immediately above the forced Realm open (`try! Realm(...)`). Build 291's compiled types were module-qualified as `Trust.*`, while build 292's compiled types were qualified as `BlockMed.*`. Realm persists those qualified names. Because the product rename silently changed the Swift module identity without a corresponding data migration, build 292 could not open the existing `shared.realm` database and the forced `try!` terminated the app.

This was a verified defect in build 292 and correcting the module identity was necessary, but the build 293 device result proved it was not sufficient. The installed Realm database still reports schema version 77 while its stored schema is incompatible with the hibernated source model. Because build 293 also declared schema 77, Realm did not enter its migration path and the forced database open failed at the same launch line.

The module comparison was verified directly from the archived binaries:

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
- App Review replacement: build 292 submission removed; build 293 attached as the only review item
- Final submission: manually completed by the owner after the prepared `4.0.1 (293)` draft was verified
- TestFlight launch result: failed; immediate crash confirmed by the owner

The legacy Realm dependency is device-only, so the iOS simulator cannot reproduce this device database path. The affected iPhone does not need a cable: install build 293 from TestFlight after Apple finishes processing it, open it over the air, and confirm that the existing wallet view loads without a crash.

## App Store completion checklist

Completed:

- Apple processed build 293.
- Build 293 was assigned to the `App Store Connect Users` internal TestFlight group.
- The review submission containing build 292 was removed.
- Build 293 was attached as the sole item for version 4.0.1.
- Reviewer notes were updated and the owner manually submitted build 293 to App Review.

Superseded verification:

Build 293 failed its in-place TestFlight launch check and is superseded by build 294. See `BlockMed-4.0.1-build-294.md`.

Do not delete the app before the TestFlight check: deletion would remove the existing Realm data and would not validate the upgrade-path fix.
