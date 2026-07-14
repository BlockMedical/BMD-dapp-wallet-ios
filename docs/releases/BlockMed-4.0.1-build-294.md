# BlockMed iOS 4.0.1 (Build 294) Realm Migration Release Record

Date: July 13, 2026 (America/Los_Angeles)  
App Store Connect app ID: `1447441652`  
Bundle ID: `ai.blockmed.wallet`  
Apple team: `AYN7MX9997`

## Status

Build 294 supersedes crash-affected builds 292 and 293. The source fix is complete, the production iPhone Release build succeeds, and a versioned archive exists at `build/BlockMed-4.0.1-294.xcarchive`.

The archive reports version `4.0.1` and build `294`. Xcode signed and uploaded it successfully at approximately 10:04 PM PDT, and Apple reported that the package is processing. Final App Review submission remains an owner action.

## Revised crash diagnosis

Build 293 restored the internal Swift module name to `Trust`, but the affected iPhone still crashed immediately. App Store Connect grouped the new build 293 feedback under the same launch signature as build 292:

`swift_unexpectedError` in `AppDelegate.application(_:didFinishLaunchingWithOptions:)`

The failing statement remains the forced `try! Realm(configuration:)` open of `shared.realm`. The remaining compatibility issue is a stored Realm schema that reports version 77 but does not match the hibernated source model. With the application also declaring version 77, Realm refuses the open before its migration block can reconcile the schema.

## Build 294 correction

- Retains `PRODUCT_MODULE_NAME = Trust` for the historical Realm model identity.
- Advances `dbMigrationSchemaVersion` from 77 to 78.
- Forces Realm to execute the existing migration path on an in-place update rather than treating the incompatible schema as current.
- Preserves the database; no Realm file, wallet metadata, or keychain material is deleted or reset.
- Advances all production/development build-number settings from 293 to 294.
- Retains the visible BlockMed name, production bundle ID, and restored blue mesh icon.

## Verification

- Scheme: `BlockMed-Prod`
- Configuration: Release
- SDK/destination: generic iPhone device, arm64
- Version/build: `4.0.1 (294)`
- Bundle: `ai.blockmed.wallet`
- Swift module: `Trust`
- Realm schema: `78`
- Production Release compilation: successful
- Archive creation: successful
- Archive metadata: confirmed `4.0.1 (294)`
- TestFlight upload: successful; Apple package processing started
- In-place TestFlight launch: pending build processing and owner verification

## Required TestFlight test

Do not delete BlockMed from the affected iPhone. Install build 294 over the existing TestFlight installation so the launch exercises the schema-77 database.

1. Confirm the first cold launch completes.
2. Confirm the existing wallet list is present.
3. Background and foreground the app.
4. Force-close and confirm a second cold launch.
5. Record the result here before attaching build 294 to App Review.
