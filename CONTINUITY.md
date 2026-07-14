# BlockMed-iOS — current state (single live status file)

Updated: 2026-07-14 ~11:15 AM PDT (end of launch-crash debugging session)

## Where things stand

- **Build 298 (4.0.1) uploaded to App Store Connect at 11:02 AM 2026-07-14.**
  Status when session ended: still processing (TestFlight showed 297; no
  processing email yet — normal within the first hour).
  `ITSAppUsesNonExemptEncryption=false` is set, so no manual export-compliance
  step; 298 becomes testable automatically once processing finishes.
- Branch: `appstore-refresh-2026-07-13`, HEAD `41d6f573`
  ("Fix all 4.0.1 launch crashes by replacing Realm 3.7.6 in build 298").
- Full root-cause analysis + fix details + on-device validation record:
  `docs/releases/BlockMed-4.0.1-build-298.md`. Read that before touching
  anything startup- or Realm-related.

## One-paragraph root cause (why 292–297 all crashed)

Realm 3.7.6 (2018) compiled with Xcode 26 cannot register Swift model
properties → first `Realm()` open threw an uncatchable Obj-C `RLMException`
("Primary key property 'id' does not exist on object 'WalletObject'") on
every launch of every 4.0.1 build. Fixed by upgrading Realm/RealmSwift to
20.0.4 and quarantining legacy-format Realm files once (recovery generation
`BlockMedRealmRecovery298.<filename>`). Wallet keys (Documents/keystore +
Keychain) unaffected — verified on the owner's iPhone 12: wallet intact,
4 clean cold launches, no crash logs.

## Next session — do this

1. Check TestFlight: build 298 processed? Install over 297 on the iPhone 12,
   confirm two cold launches + wallet access (first launch resets
   token/transaction caches by design; they re-sync).
2. If good → attach 298 to the App Review submission.
3. If 298 crashes on TestFlight (unlikely — validated locally in Release
   config on device): device logs will contain `BM-DIAG` NSLog markers
   pinpointing the failing step; get the .ips crash log from
   Settings → Privacy → Analytics Data or Xcode Organizer.
4. Optional cleanup for build 299: remove BM-DIAG NSLogs; consider
   ENABLE_BITCODE=NO (currently YES, ignored by modern Xcode).

## Environment gotchas (will bite again if forgotten)

- **iCloud Desktop sync destroys `Pods/` symlinks** (it did overnight
  2026-07-13→14; caused ed25519.h "file not found" build failures).
  Cure: `pod install`. The uploaded 298 binary is immune; only local builds
  are affected. CLAUDE.md's claim that the iCloud issue was "resolved" is
  wrong for symlinks.
- Podfile now: platform iOS 16.0, `pod 'RealmSwift', '~> 20.0'`, CDN spec
  source. CocoaPods 1.16.2 on the Mac.
- Simulator builds now possible again (Realm 20 ships proper xcframeworks) —
  the old "device-binary-only Realm" limitation is gone.
- Trust target Release config sets `CODE_SIGN_IDENTITY = "iPhone Developer"`
  (automatic signing) so debug-runs of the Prod scheme install on device;
  distribution signing at upload unaffected.
- Device debugging: iPhone 12 (iOS 26.5) is paired + Developer Mode enabled.
- Mirror (`~/Projects/Wireless-Medical-GitHub`): synced 2026-07-14 with
  `Pods/` and `BlockMed-iOS/build/` excluded as regenerable (same logic as
  node_modules — see CLAUDE.md sync policy).

## Suggested pickup prompt

"Read ~/Desktop/wireless-medical/BlockMed-iOS/CONTINUITY.md. Build 298 was
uploaded 2026-07-14; verify it processed in TestFlight, have me install it
over 297 on the iPhone 12 and confirm two cold launches with wallet access,
then attach it to App Review. If anything fails, use the BM-DIAG markers and
device crash logs per the continuity doc."
