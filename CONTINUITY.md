# BlockMed-iOS — current state

Last reconciled: August 3, 2026, on the home Mac

For cross-app Apple status and authentication boundaries, first read
`../wmm-blockmed-audit-docs/CURRENT-APPLE-SUBMISSION-STATUS.md`.

## Git and released candidate

- Canonical branch: `appstore-refresh-2026-07-13`
- Application version/build: BlockMed 4.0.1 (298)
- Build 298 replaced Realm 3.7.6 with Realm 20.0.4 and fixed the launch crash
  that invalidated builds 292–297.
- Engineering record: `docs/releases/BlockMed-4.0.1-build-298.md`
- Submission record:
  `docs/releases/BlockMed-4.0.1-build-298-APPSTORE-SUBMISSION.md`

## Last verified Apple state

- Build 298 was processed, attached to version 4.0.1, and submitted for App
  Review on July 24, 2026 at approximately 9:18 PM.
- The last observed status was `Waiting for Review`.
- Version 4.0.0 remained live at that check. Its shield icon in the App Store
  Connect header was expected; build 298 contains the intended blue mesh icon.
- App Store Connect is live external state. Verify the current review outcome
  after Wayne signs in with biometrics; do not assume it is still waiting.

## Exact next action

1. Run `../wmm-blockmed-audit-docs/scripts/start-session.sh appstore`.
2. Wayne signs in to App Store Connect with biometrics.
3. Check the current 4.0.1 review outcome and record it before any action.
4. Do not replace, resubmit, remove, or release a build without Wayne's explicit
   direction based on the observed status.

## Preserved troubleshooting boundary

Builds 292–297 are superseded and must not be submitted. If build 298 has a new
runtime failure, use the build-298 engineering record and device crash evidence;
do not revert to the legacy Realm dependency or diagnose iCloud/Pods damage as an
AWS or credential problem.
