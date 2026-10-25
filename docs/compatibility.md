# Compatibility

Last Launcher keeps your settings, pinned apps and tasks on your phone, and
updates have to bring them along untouched. This page says what a release may
and may not change. Changes are listed in [CHANGELOG.md](../CHANGELOG.md).

Last Launcher's version is `MAJOR.MINOR.PATCH`. A minor or patch release
breaks nothing below. A major release may, and the changelog then says what
changed and what to do.

## Stored data

Every key in [Data model](data-model.md), declared in `SettingsState`,
`HomeState`, `AppListState` and `TaskState`.

- **Renaming or removing a key** is breaking: it's where existing users'
  choices are. Don't.
- **Changing what a value means**, such as a default or the shape of a JSON
  value, needs a step in `SettingsState._migrate` that rewrites the old value
  before anything reads it, and a test that loads the old one. That's how the
  old Extra theme became a set of look options in 1.3.0.
- **Choices are stored by name.** Reordering an enum's values is safe;
  renaming one is breaking.
- **App keys** are `<package>|<work>`, plus `|<shortcut id>` for a shortcut
  (`AppInfo.keyFor`). Pins, labels and hidden apps are stored under them, so
  changing the format loses them all.
- **Adding** a key, or a key inside a JSON value, is not breaking. An older
  version ignores it.
- **A value of the wrong type**, stored by another version, reads as unset and
  gets its default; it never crashes the launcher. In a stored list, an entry
  that can't be read is left out.

## Backups

The file is described in [Data model](data-model.md#backups).

- **Every backup restores** in every later release, through the same
  migrations as stored data. The "older backups" tests in
  `test/backup_test.dart` restore backups from earlier releases; a change to
  the format or to a stored value adds one.
- **`version`** goes up when a backup can't be read the old way. A release
  refuses a backup with a newer version than it knows, rather than restoring
  part of it.
- **A search prefix of a type** this release doesn't know, from a newer one,
  is skipped; the rest still work.

Going back to an older release isn't something Android allows: it won't
install a lower version over a higher one, so you'd have to uninstall first,
which removes everything. Export a backup before you do. An older release
restores it, ignoring keys it doesn't know, unless the backup's `version` is
newer than it reads.

## A synced task list

- **The tasks app's provider**: the OpenTasks contract that Tasks.org and
  OpenTasks share, with the authorities and permissions DAVx⁵ uses. Reading
  or writing more of it than [Data model](data-model.md#the-synced-task-list)
  lists needs saying in the README's disclosure section, `SECURITY.md` and
  `PRIVACY_POLICY.md` first.
- **`task_source` and `synced_task_view`** mean something on this phone only,
  so they're never backed up. Each list keeps its own order and hidden tasks.

## Store listing

- **The package name** `nl.bw20.last_launcher` and **the signing keys** never
  change: Android would treat it as another app, and updates would stop.
- **The version code** only goes up.

## Not covered

These can change in any release:

- How the screens look, and the words on them.
- The method channel between Dart and Kotlin: it's only for the launcher
  itself.
- The Dart and Kotlin code, and how it's laid out.
- The order of a synced task list after its tasks change elsewhere: tasks the
  launcher hasn't seen yet come first.
- The store listings and their screenshots.
