# Architecture

Last Launcher is a Flutter app for Android only. The Dart side draws
everything and holds every rule; a thin Kotlin side does what only Android
can: list and open apps, read pinned shortcuts, lock the screen, and open the
system's file pickers and settings.

## Where state lives

- **SharedPreferences is the record.** Settings, pinned apps, labels, hidden
  apps, search prefixes and tasks are all keys in it, read at start and
  written on every change. Nothing else is stored, and nothing leaves the
  phone. Android's own backup is off (`allowBackup="false"`); Backup &
  restore is the way to move it.
- **The app list is asked for, not stored.** It comes from Android on start
  and every time the launcher comes back to the front, and anything pinned,
  labelled or hidden for an app that's gone is dropped then.
- **Shortcuts stay with Android.** A shortcut another app asks to pin is
  accepted by `PinShortcutActivity` and kept by Android; the launcher lists
  them with the apps.

## Layers

```mermaid
flowchart TD
    UI[Screens and widgets<br/>home, app drawer, modules, settings] --> state
    state[State<br/>SettingsState, HomeState, AppListState, TaskState] --> prefs[(SharedPreferences)]
    UI --> rules[Pure rules<br/>search, ranking, hints, prefixes, shell gestures, backup]
    state --> rules
    state --> channel[AppChannel<br/>lib/shared/data/app_channel.dart]
    channel -->|MethodChannel nl.bw20.last_launcher/apps| kotlin[MainActivity.kt<br/>apps, shortcuts, launching, pickers]
    kotlin --> lock[LockAccessibilityService.kt]
```

- **`main.dart`** builds the four states and the channel, loads the apps once,
  and starts `LastLauncherApp`.
- **`app.dart`** builds the theme from the look options and the system accent,
  and refreshes apps and the accent whenever the launcher comes back to the
  front.
- **`features/home/screens/launcher_shell.dart`** is the one screen: home in
  the middle, a module on each side, and the app drawer as a sheet over it.
  It keeps the pointer state and animations; what a drag means, and where it
  settles, is decided in `shell_gestures.dart`.

### State

Each state is a `ChangeNotifier` that owns its keys:

- **`SettingsState`** (`features/settings/`): every setting, declared once
  with its key, type and default. Rules that tie settings together are getters
  (`autoLaunchActive`, `quickLaunchHintsAvailable`), never writes, so a choice
  comes back when the rule stops applying. `_migrate` rewrites values stored
  by older versions before anything reads them.
- **`HomeState`** (`features/home/`): the pinned apps, and how many fit.
- **`AppListState`** (`features/app_drawer/`): the installed apps, custom
  labels, hidden apps and the current search.
- **`TaskState`** (`features/modules/tasks/`): the task list, on the phone
  or in a tasks app (see [Synced tasks](#synced-tasks)).

After a restore, each one re-reads everything with `reload()`, so nobody has
to restart the launcher.

### Pure rules

The decisions are in plain Dart without widgets, and each has a test:

- **Search** (`app_drawer/search.dart`, `ranking.dart`): a query is split into
  a prefix and a search term, matched against names with accents folded away
  (`shared/data/fold_for_search.dart`), and ranked. `DrawerResults` is built
  once per query and shared by the list, auto-launch and the keyboard's enter
  key, so all three agree on which app a query means.
- **Quick launch hints** (`shared/data/hints.dart`): the shortest part of
  each name that no other name has.
- **Search prefixes** (`app_drawer/prefixes.dart`): filters for work or
  personal apps, links, and searches in an app. A prefix type that a newer
  version added is skipped, not an error.
- **Shell gestures** (`home/shell_gestures.dart`): what a drag becomes, where
  it follows the finger and where it settles.
- **Synced tasks** (`modules/tasks/synced_tasks.dart`): a list in a tasks
  app read into the same flat list, the changes to write back, and which done
  tasks are hidden.
- **Subtasks** (`modules/tasks/subtasks.dart`): the task list is stored flat,
  and a task marked `indented` belongs to the top-level task above it. Which
  group a task is in, what ticking off, removing and moving one does to its
  family, and which way a sideways drag goes.
- **Backup** (`settings/backup.dart`): the file format, see
  [Compatibility](compatibility.md).

### Modules

The left and right of home each hold a module: none, Tasks or Launch app. A
module implements `LauncherModule` (`features/modules/launcher_module.dart`)
and is added to `launcherModules`; the settings, the hints on home and backups
pick it up from there. A module's own data, such as the tasks, is listed in
`storageKeys`, so a backup can leave it out.

### Synced tasks

The Tasks module's list can be one in Tasks.org or OpenTasks instead of the
phone's, chosen under **Tasks from** (`task_source`, `<authority>/<list id>`).
Both apps share OpenTasks' provider contract; DAVx⁵ syncs them with CalDAV.

- **Reading:** `TaskState` asks `TaskProviders.kt` for the list's rows and
  turns them into the flat list with `arrangeSynced`: subtasks under their
  top-most task, in the order stored on the phone (`synced_task_view`), new
  tasks first. It reads again when the provider says something changed, and
  when the launcher comes back to the front.
- **Writing:** every change goes through the same rules as the phone's list.
  `syncedChanges` turns before and after into inserts, updates and deletes,
  which `TaskProviders.kt` makes in order; tasks added here then get the
  provider's ids. The order isn't written: CalDAV has none that apps share.
- **Done tasks:** Remove on complete and Clear completed daily hide them
  (still in `synced_task_view`) unless **Delete done tasks everywhere** is on.
- **Problems** (the app gone, no permission, the list gone) are a
  `TaskSyncStatus`, which the task list shows with a tap to put it right.
- `task_source` and `synced_task_view` hold this phone's provider ids, so
  they're never backed up, and a restore leaves them alone.

### The Kotlin side

`android/app/src/main/kotlin/nl/bw20/last_launcher/`:

- **`MainActivity.kt`** answers the method channel: the apps of every profile
  (skipping a paused work profile) and their pinned shortcuts, launching,
  App info, quick settings, fullscreen, the system accent, opening links and
  app searches for prefixes, the file pickers for backups, and whether this is
  the default launcher. It tells the Dart side when home is pressed
  (`goHome`) or when the system asks for the settings (`openSettings`).
- **`PinShortcutActivity.kt`** accepts "Add to home screen" requests.
- **`TaskProviders.kt`** reads and writes one task list in Tasks.org or
  OpenTasks through their OpenTasks provider, and tells the Dart side when it
  changes.
- **`LockAccessibilityService.kt`** locks the screen, and does nothing else.
  Its configuration can't read window content.

## Looks

The look is a set of separate options in `SettingsState`; Standard and Extra
are presets of them, worked out from the options rather than stored.
`app_theme.dart` turns them into a `ThemeData` per brightness, and
`AppearanceScope` hands the rest (text size, alignment, effects) to the
widgets. Alignment is left everywhere but on home: `LauncherShell` wraps
`HomeScreen` in a scope with the Alignment setting's own. Glow and scanlines
only show in dark mode.

## Translations

The interface is in English and Dutch: `lib/l10n/app_<code>.arb`, with English
(`app_en.arb`) as the template. `flutter gen-l10n` turns them into the
`app_localizations*.dart` files next to them, which are committed. The store
listings are in `fastlane/metadata/android/<locale>/`.
