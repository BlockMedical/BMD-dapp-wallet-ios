# BlockMed iOS 4.0.1 (Build 292) Release Record

> Superseded: TestFlight crash reports showed that build 292 crashed during Realm startup because changing the product name also changed the Swift module name from `Trust` to `BlockMed`. See [build 293](BlockMed-4.0.1-build-293.md) for the data-compatible correction.

Date completed: July 13, 2026 (America/Los_Angeles)  
App Store Connect app: BlockMed  
Apple app ID: `1447441652`  
Bundle ID: `ai.blockmed.wallet`  
Apple team ID: `AYN7MX9997`

## Outcome

BlockMed iOS 4.0.1 build 292 was rebuilt from the historical BlockMed product branch, restored to the original blue mesh app icon, signed, uploaded to App Store Connect, processed successfully, assigned to the internal TestFlight group, and prepared for App Review. The owner confirmed that the final submission to Apple was completed.

The exact source used for the submitted build is preserved on GitHub in branch `appstore-refresh-2026-07-13` of `BlockMedical/BMD-dapp-wallet-ios`.

## Source provenance

- Repository: <https://github.com/BlockMedical/BMD-dapp-wallet-ios>
- Historical product source: `origin/blockmed`
- Submitted-source branch: `appstore-refresh-2026-07-13`
- Restoration commit: `d134c235` (`Restore BlockMed release with blue mesh icon`)
- Version commit: `183040c1` (`Advance BlockMed release to 4.0.1`)
- The repository default branch is upstream Trust Wallet code and was not used as the BlockMed product baseline.

## App identity and release configuration

- Marketing version: `4.0.1`
- Build number: `292`
- Production scheme: `BlockMed-Prod`
- Display name: `BlockMed`
- Production bundle ID: `ai.blockmed.wallet`
- Minimum iOS version: iOS 16.0
- Supported device family: iPhone only
- Architecture: arm64
- App Store encryption declaration: `ITSAppUsesNonExemptEncryption = false`
- Keychain namespace: `ai.blockmed.wallet`
- App Store release behavior retained from the existing listing: automatic release after approval and immediate availability to all users.

## Restored blue mesh icon

The production AppIcon set in `Trust/Assets.xcassets/AppIcon.appiconset` is the historical BlockMed blue mesh artwork from the `blockmed` branch. The compiled 120-by-120 iPhone icon in the signed archive was visually compared with the source artwork before upload.

This replaces the blue shield icon embedded in builds 290 and 291. Development and beta icon sets remain separate and do not affect the production `BlockMed-Prod` archive.

## BlockMed integrations retained

The submitted source preserves the BlockMed-specific wallet and ecosystem behavior that belongs in the iOS application:

- BlockMed API: `https://api.blockmed.ai`
- Ethereum RPC: `https://ethereum-rpc.publicnode.com`
- BlockMed IPFS base: `https://ipfs.blockmed.me/`
- Website and DApp entry point: `https://blockmed.ai`
- Support: `https://blockmed.ai/support`
- Privacy: `https://blockmed.ai/privacy`
- Terms: `https://blockmed.ai/terms`
- BMD and BlockMed token initialization in the wallet data store
- BlockMed registration and IPFS metadata transaction behavior
- BlockMed social and support identifiers

Server, deployment, contract, IPFS-node, event-listener, desktop-wallet, research, and documentation repositories were reviewed as ecosystem dependencies or historical references. Their source is not supposed to be copied into an iOS application binary. The app contains the appropriate client integrations, endpoints, token definitions, and transaction behavior instead.

## BlockMedical repository inventory reviewed

All 19 repositories visible in the BlockMedical organization on July 13, 2026 were reviewed:

### iOS and mobile clients

- `BMD-dapp-wallet-ios` — production iOS wallet source used for this release
- `BMD-mobile_app_projects` — mobile project index
- `BMD-Qtum-Wallet` — historical Qtum wallet
- `QWallet` — historical wallet

### Smart contracts and token projects

- `BMD-smartcontract-v2`
- `BMD-smartcontract`
- `BMD-contract-deployment`
- `BMV-ventureasset`
- `BLOCKMED-ERC20-Token`

### IPFS, backend, and infrastructure

- `bc-ipfs-wmm`
- `bc-ipfs`
- `bc-ipfs-node`
- `BMD-ansible-deployment`
- `BMD-exchange-rate-updater`
- `BMD-eth-event-listener`

### Desktop, research, and project documentation

- `Orion`
- `BMD-distributed_hosting_projects`
- `BMD-deep_learning_projects`
- `BlockMedical`

## Compatibility and security work

The release branch also preserves or adds the changes required to produce a current signed archive:

- iOS 16 deployment target and Xcode compatibility updates
- iPhone-only production target
- Public Ethereum RPC endpoint that requires no external service key
- BlockMed product URLs and keychain namespace
- App Transport Security configuration for BlockMed domains
- Camera and photo-library purpose descriptions for QR import and scanning
- arm64 production configuration
- Release signing configuration without development-only entitlement leakage
- Swift compatibility fixes for current Xcode and simulator conditionals
- JSONRPCKit 3.x dependency compatibility
- Reproducible TrezorCrypto 0.0.9 source submodule at `Vendor/TrezorCrypto`

## Build and validation

The following validation was completed:

- CocoaPods dependencies resolved from the committed `Podfile.lock`.
- Unsigned Release build succeeded.
- Signed archive succeeded.
- Archive metadata reports version 4.0.1, build 292, arm64, bundle `ai.blockmed.wallet`, team `AYN7MX9997`, and scheme `BlockMed-Prod`.
- The compiled production icon was checked against the historical blue mesh source.
- App Store Connect package analysis completed with no upload errors or warnings.
- Apple upload completed at July 13, 2026 7:49 PM PDT.
- App Store Connect upload identifier: `288b7497-85d6-43b1-91a6-4cc47a9ab777`.
- TestFlight status became `Ready to Submit` and build 292 was assigned to `App Store Connect Users` internal testing.
- App Store version 4.0.1 was created, build 292 was attached, metadata was saved, and the submission draft reached `Ready for Review`.
- The owner completed the final `Submit for Review` action.

The first attempted refreshed upload used version 4.0.0 and was correctly rejected because Apple had already approved and closed that version train. The source was advanced to 4.0.1, rebuilt, and uploaded successfully as build 292.

## App Store metadata prepared

The 4.0.1 listing inherited the approved 4.0.0 description, screenshots, keywords, support URL, marketing URL, copyright, review contact information, and existing release settings.

The release notes were updated to state that 4.0.1:

- Restores the original BlockMed blue mesh app icon.
- Aligns the production app with the hibernated BlockMed wallet branch.
- Retains BlockMed API, IPFS, BMD token, and public Ethereum network integrations.
- Includes iOS 16 compatibility and security hardening.

The reviewer notes were updated for build 292, including the no-login self-custody wallet flow, the restored icon, the BlockMed display name, iPhone-only configuration, and public Ethereum RPC behavior.

## Local artifacts

- Working copy: `/Users/waynechung/Desktop/wireless-medical/BlockMed-iOS`
- Signed archive: `/Users/waynechung/Library/Developer/Xcode/Archives/2026-07-13/BlockMed 4.0.1 (292)-signed.xcarchive`
- Export output: `/Users/waynechung/Desktop/wireless-medical/BlockMed-iOS/AppStore-Export-4.0.1-292`
- Local release record: `/Users/waynechung/Desktop/wireless-medical/BlockMed-4.0.1-build-292-release-record.md`

The `.xcarchive` and exported IPA are intentionally not committed to GitHub. GitHub preserves the exact source, dependency lockfile, submodule reference, export configuration, build settings, and this release record. Apple retains the notarized uploaded binary.

## Future rebuild procedure

1. Clone `BlockMedical/BMD-dapp-wallet-ios` and check out the preserved release branch or release tag.
2. Initialize submodules recursively.
3. Install pods from the committed lockfile.
4. Open `Trust.xcworkspace` in Xcode.
5. Select the `BlockMed-Prod` scheme and the Wireless Medical Monitoring development team.
6. Increase both the marketing version and build number before a new App Store upload.
7. Archive for a generic iOS device using Release configuration.
8. Verify the compiled app name, bundle ID, blue mesh production icon, version, build, signing team, and absence of development entitlements.
9. Upload through Xcode Organizer or the committed App Store export configuration.
10. Confirm processing and TestFlight behavior before attaching the build to a new App Store version.

Do not rebuild a future BlockMed release from the repository default `master` branch unless the BlockMed product changes have first been intentionally reconciled into it.
