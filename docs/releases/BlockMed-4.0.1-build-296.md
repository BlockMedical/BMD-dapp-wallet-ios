# BlockMed iOS 4.0.1 (Build 296) Immediate Realm Quarantine Release Record

Date: July 13, 2026 (America/Los_Angeles)  
App Store Connect app ID: `1447441652`  
Bundle ID: `ai.blockmed.wallet`

## Status

Build 295 stopped the fatal Realm exception but remained indefinitely on a white screen while synchronously copying the legacy Realm files. Build 296 replaces file copying with same-volume moves and quarantines the legacy shared Realm before attempting to open it.

## Correction

- On the first build-296 launch, moves `shared.realm` and existing sidecars into a timestamped `BlockMed-Realm-Recovery-*` directory.
- A same-volume move updates filesystem entries instead of copying the database contents, avoiding the build-295 startup delay.
- Opens a new shared Realm at schema version 80 only after quarantine succeeds.
- Retains guarded error handling and the non-crashing recovery screen.
- Does not target encrypted wallet files in `Documents/keystore` or passwords in iOS Keychain.

The clean shared Realm does not retain metadata stored only in the quarantined Realm, including wallet labels, watch-only addresses, and cached shared data. The original Realm remains preserved in the recovery directory.

## Required TestFlight test

Install build 296 over the existing app without deleting it. Confirm the interface appears promptly, encrypted wallets are accessible, background/foreground works, and a second cold launch succeeds. Do not attach the build to App Review until these checks pass.
