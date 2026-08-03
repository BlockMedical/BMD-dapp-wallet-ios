# BlockMed iOS 4.0.1 (Build 298) Launch Crash Root Cause and Fix

Date: July 14, 2026 (America/Los_Angeles)
App Store Connect app ID: `1447441652`
Bundle ID: `ai.blockmed.wallet`

## Root cause (found with debugger on physically connected iPhone 12, iOS 26.5)

Builds 292–297 all died at launch from the same underlying defect, which was
never Realm *file* corruption:

1. **Realm 3.7.6 (2018) is incompatible with the Xcode 26 toolchain.** When
   the app is compiled with Xcode 26, Realm's schema registration cannot see
   any Swift model properties. The first `Realm(configuration:)` call throws
   an Objective-C `RLMException` — *"Primary key property 'id' does not exist
   on object 'WalletObject'"* — from `RLMSchema sharedSchema` /
   `RLMRegisterClass`, on **every** launch, on **every** device.
2. Because it is an Objective-C exception, none of the Swift `do/try/catch`
   guards added in builds 294–297 could catch it. Every 4.0.1 build was dead
   on arrival; the previously working 4.0.0 was built years ago with a
   matching old toolchain.
3. Confirmed empirically: exception breakpoint stopped at
   `RLMRegisterClass(Trust.WalletObject)`; all 10 TestFlight crash instances
   in Organizer (builds 292/293) share the
   `swift_unexpectedError → didFinishLaunchingWithOptions` signature.
4. After upgrading Realm, a second latent defect surfaced: the on-device
   Realm files written by the 2018 file format survive Realm 20's in-place
   format upgrade but then fault (`EXC_BAD_ACCESS` in
   `realm::Group::get_table_unchecked`) on first query
   (`TokensDataStore` init). The legacy files are unusable under Realm 20.

## Build 298 changes

- **Realm/RealmSwift upgraded 3.7.6 → 20.0.4** (`pod 'RealmSwift', '~> 20.0'`,
  Podfile platform raised to iOS 16.0, spec source switched to
  `cdn.cocoapods.org`). v20 is the first release line supporting Xcode 26.
- Removed obsolete Realm 3.x initializer boilerplate
  (`required init(value:schema:)`, `required init(realm:schema:)`,
  `required init()`) from `CoinTicker`, `TokenObject`,
  `CollectibleTokenObject`, `CollectibleTokenCategory`.
- `realm.add/create(..., update: true)` → `update: .all` (14 call sites).
- **New recovery generation `BlockMedRealmRecovery298.<filename>`** (shared
  key unified between `AppDelegate` and `InCoordinator`): on first 298
  launch every legacy Realm file is quarantined (moved to a timestamped
  `BlockMed-Realm-Recovery-*` folder, never deleted) before Realm 20 ever
  maps it, and a fresh file is created. Realm holds only re-syncable caches
  (tokens, transactions, bookmarks, tickers); **wallet keys live in
  `Documents/keystore` and the iOS Keychain and are untouched.**
- Added `BM-DIAG` NSLog launch markers across
  `AppDelegate` → `RealmRecovery` → `AppCoordinator` → `InCoordinator` for
  field diagnosis of any future launch issue (no sensitive data logged).
- Trust target Release config now sets `CODE_SIGN_IDENTITY = "iPhone
  Developer"` so automatic signing can produce runnable device builds (the
  project-level empty identity previously yielded an unsigned executable).
- Build number advanced to 298. Realm schema version stays 81.

## Also fixed in the working copy (not code)

The Pods tree had been mangled by iCloud Desktop sync (deleted
`Pods/Headers` symlinks, duplicate `Sources 2/3` folders in TrustCore) —
that was the cause of this morning's `ed25519-donna/ed25519.h` build
failures, unrelated to the runtime crash. Clean `pod install` restored it.
**Caution:** symlinks inside `Pods/` will not survive iCloud sync; expect to
re-run `pod install` after the folder round-trips through iCloud.

## Validation on device before upload (iPhone 12, iOS 26.5, over existing install with wallet data)

- Debugger runs: shared + per-wallet Realm open clean (quarantine of legacy
  files observed via BM-DIAG markers), keystore loads, wallet UI reachable.
- 4 cold launches from the Home Screen without debugger (watchdog active):
  main UI with wallet every time; background/foreground cycle clean.
- No new crash logs on device after the fixed build was installed
  (verified in device crash log directory).

## Remaining TestFlight test for build 298

Install over the previous TestFlight build. First launch quarantines legacy
databases (token list/transaction history reset and re-sync; wallets remain).
Confirm two cold launches and wallet access before attaching to App Review.
