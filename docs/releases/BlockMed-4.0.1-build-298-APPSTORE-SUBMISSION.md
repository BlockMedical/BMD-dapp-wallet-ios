# BlockMed 4.0.1 (Build 298) — App Store submission record

Date: July 24, 2026 (America/Los_Angeles)
App Store Connect app ID: `1447441652`
Bundle ID: `ai.blockmed.wallet`

Companion to `BlockMed-4.0.1-build-298.md`, which covers the engineering fix.
Full cross-app session record: `wmm-blockmed-audit-docs/APP-STORE-CONNECT-SUBMISSION-2026-07-24.md`.

---

## Status

**4.0.1 Waiting for Review** as of Jul 24, 2026 ~9:18 PM. Apple quotes up to 48 hours.
4.0.0 remains Ready for Distribution and live on the App Store.

## What changed on the version record

1. **Attached build 293 → 298.** The record had been left pointing at 293, one of the builds
   that crashed at launch on every device (Realm 3.7.6 incompatible with the Xcode 26
   toolchain). Version status moved Developer Rejected → Prepare for Submission on save.

2. **"What's New in This Version" rewritten.** Previous text described build-293 content and
   omitted the crash fix entirely. Current text:

   ```
   Version 4.0.1

   • Fixes a crash on launch that affected this version on current iOS releases.
     The app now starts reliably.
   • Updates the underlying local database engine for compatibility with the current
     iOS toolchain.
   • Local caches written by much older versions are automatically set aside on first
     launch and rebuilt. Wallet keys live in the keystore and the iOS Keychain and are
     not touched by this process.
   • Restores the original BlockMed blue mesh app icon.
   • Aligns the production app with the hibernated BlockMed wallet branch.
   • Retains BlockMed API, IPFS, BMD token, and public Ethereum network integrations.
   ```

3. **Submitted for review.** Draft submission validated with zero errors.

Not changed: description, keywords, support/marketing URL, screenshots, copyright.

## App icon — expected behaviour, no action required

App Store Connect shows the **blue shield** in the app header and Apps grid. That is the icon of
**4.0.0**, the version currently live. It is not the icon 4.0.1 will ship with.

The App Store product-page icon is read from the build's asset catalog and shown read-only at
**Build → Included Assets → App Icon**. For 4.0.1 that asset is the **blue mesh graph** icon,
because build 298 carries it — visible in the TestFlight build list, where rows 296, 297 and
298 all render the mesh icon. The header will switch to the mesh icon once 4.0.1 is approved
and released.

There is no separate icon upload in App Store Connect. Changing the icon requires a new archive
from Xcode.

## Follow-up

- **Age rating — social media questions.** Due **Sept 7, 2026**. App Information → Age Ratings.
  App Store Connect is showing this banner on the BlockMed record.
- Editing metadata further, or attaching a different build, requires removing 4.0.1 from review
  first.
