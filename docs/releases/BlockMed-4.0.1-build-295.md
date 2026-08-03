# BlockMed iOS 4.0.1 (Build 295) Guarded Realm Recovery Release Record

Date: July 13, 2026 (America/Los_Angeles)  
App Store Connect app ID: `1447441652`  
Bundle ID: `ai.blockmed.wallet`  
Apple team: `AYN7MX9997`

## Status

Build 295 did not crash, but its in-place TestFlight launch remained indefinitely on a white screen. Its synchronous copy-based Realm preservation blocked startup on the affected installation. Build 296 supersedes it; build 295 must not be submitted to App Review.

## Correction

- Replaces the forced `try! Realm(configuration:)` startup open with `do/catch` handling.
- First attempts the normal migration at Realm schema version 79.
- If the shared Realm cannot open, copies `shared.realm` and its existing sidecar files into a timestamped `BlockMed-Realm-Recovery-*` directory before removing the originals.
- Creates a fresh shared Realm only after the backup completes.
- Shows a non-crashing recovery message if backup or recreation fails.
- Removes the separate protected-data `fatalError` launch path.
- Leaves encrypted wallet files in `Documents/keystore` and wallet passwords in iOS Keychain untouched.
- Advances production/development build settings to 295.

The recreated shared Realm can lose local metadata stored only in that Realm, including wallet labels, watch-only addresses, and cached shared data. The encrypted keystore and Keychain credentials are not targeted by recovery.

## Verification

- Scheme: `BlockMed-Prod`
- Configuration: Release
- SDK/destination: generic iPhone device, arm64
- Version/build: `4.0.1 (295)`
- Bundle: `ai.blockmed.wallet`
- Swift module: `Trust`
- Realm schema: `79`
- Production Release compilation: successful
- In-place TestFlight launch: **failed; indefinite white screen confirmed by owner**

## Required TestFlight test

Do not delete BlockMed from the affected iPhone. Install build 295 over the existing TestFlight installation.

1. Confirm the app opens instead of terminating.
2. Confirm encrypted wallets are visible and accessible.
3. Background and foreground the app.
4. Force-close and confirm a second cold launch.
5. Submit to App Review only after these checks pass.
