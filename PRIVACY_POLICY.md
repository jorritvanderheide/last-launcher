# Privacy Policy — Last Launcher

**Last updated:** 2026-04-15

Welcome to Last Launcher for Android!

This is an open-source app developed by BW20, published under the EUPL 1.2 licence. The source code is available on GitHub.

As an Android user myself, I take privacy very seriously. I know how frustrating it is when apps collect your data without your knowledge. Last Launcher was built with one principle: your data belongs on your device, nowhere else.

I hereby state, to the best of my knowledge and belief, that I have not programmed this app to collect any personally identifiable information. All data created by you (the user) is stored locally on your device only, and can be erased by clearing the app's data or uninstalling it. No analytics or tracking software is present in the app.

## Data stored on your device

- **Pinned apps** — app package names, custom labels, and display order are stored locally via SharedPreferences.
- **Tasks** — task titles, completion state, and display order are stored locally via SharedPreferences.
- **Hidden apps** — package names of apps you have chosen to hide are stored locally via SharedPreferences.
- **Preferences** — theme, keyboard behavior, and other settings are stored locally via SharedPreferences.

## Network requests

The app makes **no network requests**. Last Launcher works entirely offline. No data ever leaves your device.

## Explanation of permissions requested in the app

The list of permissions required by the app can be found in the [`AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml) file:

| Permission | Why it is required |
| :---: | --- |
| `android.permission.QUERY_ALL_PACKAGES` | Required to list all installed apps so they can be displayed in the app drawer. Automatically granted by the system; cannot be revoked by the user. |
| `android.permission.EXPAND_STATUS_BAR` | Required to expand the quick settings panel via a swipe gesture on the home screen. Automatically granted by the system; cannot be revoked by the user. |

No permissions need to be granted manually by the user.

## What the app does NOT do

- No analytics or telemetry
- No crash reporting services
- No advertising
- No user accounts or cloud sync
- No tracking of any kind
- No network requests of any kind
- No Google Play Services dependency

## Children's privacy

The app does not knowingly collect any data from anyone, including children under 13. Since no personal data is collected at all, no age-specific provisions are necessary.

## Data sharing

Last Launcher does not share any data with third parties. There is no data to share — nothing is collected.

## Data retention

All data is stored locally on your device. Uninstalling the app removes all associated data. There is no server-side data to delete.

## Changes to this policy

Updates to this policy will be reflected in the "Last updated" date above and committed to the source repository. Since the app collects no data, material changes are unlikely.

---

If you find any security vulnerability that has been inadvertently caused by me, or have any questions regarding how the app protects your privacy, please open an issue on GitHub and I will do my best to address it.
