# Privacy Policy: Last Launcher

**Last updated:** 2026-10-25

Welcome to Last Launcher for Android!

This is an open-source app developed by BW20, published under the EUPL 1.2 licence. The source code is available on [Codeberg](https://codeberg.org/BW20/last-launcher).

As an Android user myself, I take privacy very seriously. I know how frustrating it is when apps collect your data without your knowledge. Last Launcher was built with one principle: your data belongs on your device, nowhere else.

I hereby state, to the best of my knowledge and belief, that I have not programmed this app to collect any personally identifiable information. All data created by you (the user) is stored locally on your device only, and can be erased by clearing the app's data or uninstalling it. The one exception is a task list you choose in Tasks.org or OpenTasks: its tasks are kept by that app, which may sync them with a server you set up. No analytics or tracking software is present in the app.

## Data stored on your device

- **Pinned apps**: app package names, custom labels, and display order are stored locally via SharedPreferences.
- **Tasks**: task titles, completion state, display order, and which tasks are subtasks are stored locally via SharedPreferences.
- **Tasks in another app**: if you choose a task list in Tasks.org or OpenTasks under Tasks from, its tasks stay in that app. Last Launcher reads the names of that app's lists, and the tasks in the one you chose, and writes the changes you make to those tasks back to it. Only the list's order and which done tasks are hidden are stored locally, and they are left out of backups.
- **Hidden apps**: package names of apps you have chosen to hide are stored locally via SharedPreferences.
- **Preferences**: theme, keyboard behavior, and other settings are stored locally via SharedPreferences.
- **Backups**: only when you export one, to a file and a place you choose. Restoring reads a file you pick.
- **Shortcuts**: shortcuts another app asks to add, such as a website you add to the home screen from your browser, are kept by Android and listed with your apps.

## Network requests

The app makes **no network requests**. Last Launcher works entirely offline, and never sends anything off your device itself.

A search prefix that opens a link, such as a web search, hands the link to another app, such as your browser, which then connects the way it always does. Last Launcher itself has no internet permission.

If you choose a task list in Tasks.org or OpenTasks, the tasks you add or change in Last Launcher go to that app on your device. If you set that app up to sync, for instance with DAVx⁵, it sends them to your server. Last Launcher has no part in that.

## Explanation of permissions requested in the app

The list of permissions required by the app can be found in the [`AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml) file:

| Permission / API | Why it is required |
| :---: | --- |
| `android.permission.QUERY_ALL_PACKAGES` | Required to list all installed apps so they can be displayed in the app drawer. Automatically granted by the system; cannot be revoked by the user. |
| `android.permission.EXPAND_STATUS_BAR` | Required to expand the quick settings panel via a swipe gesture on the home screen. Automatically granted by the system; cannot be revoked by the user. |
| `org.tasks.permission.READ_TASKS`, `org.tasks.permission.WRITE_TASKS`, `org.dmfs.permission.READ_TASKS`, `org.dmfs.permission.WRITE_TASKS` | Required only to use a task list from Tasks.org or OpenTasks (optional). Asked for when you choose such a list, and can be revoked in the system settings. Used to read that app's list names and the chosen list's tasks, and to write your changes to those tasks. Syncing them with a server is done by that app and DAVx⁵, not by Last Launcher. |
| `AccessibilityService` | Used only to lock the screen when the user double-taps the home screen (optional, opt-out feature). The service has no ability to read screen content, interact with UI elements, or observe user input beyond detecting the double-tap gesture used to trigger screen lock. It does not observe or collect any user data, and it is disabled by default. |

Some permissions must be granted manually by the user through system settings.

## What the app does NOT do

- No analytics or telemetry
- No crash reporting services
- No advertising
- No user accounts or cloud sync of its own (a task list you choose in Tasks.org or OpenTasks is synced by those apps, if you set them up)
- No tracking of any kind
- No network requests of any kind
- No Google Play Services dependency

## Children's privacy

The app does not knowingly collect any data from anyone, including children under 13. Since no personal data is collected at all, no age-specific provisions are necessary.

## Data sharing

Last Launcher does not share any data with third parties. There is no data to share: nothing is collected. If you choose a task list in Tasks.org or OpenTasks, the changes you make to its tasks go to that app on your phone.

## Data retention

All data is stored locally on your device. Uninstalling the app removes all associated data. There is no server-side data to delete.

## Changes to this policy

Updates to this policy will be reflected in the "Last updated" date above and committed to the source repository. Since the app collects no data, material changes are unlikely.

---

If you have questions about how the app protects your privacy, please [open an issue on Codeberg](https://codeberg.org/BW20/last-launcher/issues/new/choose). If you find a security vulnerability, please report it privately instead, as described in the [security policy](SECURITY.md).
