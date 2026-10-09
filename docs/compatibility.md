# Compatibility

Last Launcher keeps your settings, pinned apps and tasks on your phone, and
updates have to bring them along untouched. This page says what a release may
and may not change. Changes are listed in [CHANGELOG.md](../CHANGELOG.md).

Last Launcher's version is `MAJOR.MINOR.PATCH`. A minor or patch release
breaks nothing below. A major release may, and the changelog then says what
changed and what to do.

## Stored data

Everything is in SharedPreferences, under the keys declared in
`SettingsState`, `HomeState`, `AppListState` and `TaskState`.

- **Renaming or removing a key** is breaking: it's where existing users'
  choices are. Don't.
- **Changing what a value means**, such as a default or the shape of a JSON
  value, needs a step in `SettingsState._migrate` that rewrites the old value
  before anything reads it, and a test that loads the old one. That's how the
  old Extra theme became a set of look options in 1.3.0.
- **Enums are stored by name.** Reordering an enum's values is safe; renaming
  one is breaking.
- **App keys** are `<package>|<work>`, plus `|<shortcut id>` for a shortcut
  (`AppInfo.keyFor`). Pins, labels and hidden apps are stored under them, so
  changing the format loses them all.
- **Adding** a key is not breaking. An older version ignores it.
- **A value of the wrong type**, stored by another version, reads as unset and
  gets its default; it never crashes the launcher.

## Backups

A backup is a JSON file:

```json
{
  "format": "last-launcher-backup",
  "version": 1,
  "modules": ["tasks"],
  "prefs": {
    "locked": { "type": "bool", "value": false },
    "pinned_apps": { "type": "string", "value": "[...]" }
  }
}
```

`prefs` holds every stored key with its type, so a setting added later is
backed up without anyone having to remember it. `modules` lists the modules
whose own data is in it. `Backup` in `lib/features/settings/backup.dart`
reads and writes it.

- **Every backup restores** in every later release, through the same
  migrations as stored data.
- **`version`** goes up when a backup can't be read the old way. A release
  refuses a backup with a newer version than it knows, rather than restoring
  part of it.
- **A search prefix of a type** this release doesn't know, from a newer one,
  is skipped; the rest still work.

## Store listing

- **The package name** `nl.bw20.last_launcher` and **the signing keys** never
  change: Android would treat it as another app, and updates would stop.
- **The version code** only goes up.
