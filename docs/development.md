# Development

## Setup

```sh
nix develop       # flutter, the Android SDK, a JDK, mask and the formatters
flutter pub get
flutter run       # on a phone or emulator that adb can see
```

The dev shell puts `adb` from the same SDK that Gradle uses on the `PATH`.
`mask` runs the commands in `maskfile.md`: `mask check` formats, analyses and
tests in one go, and is what to run before calling a change done.

Without Nix: Flutter (the version is in `.github/workflows/ci.yml`), the
Android SDK with build tools 35 and NDK 28, and a JDK 17 or newer.

## Checks

```sh
nix fmt                         # format Dart and Nix
flutter analyze --fatal-infos   # lints, including infos
flutter test
nix flake check                 # formatting, and the Flutter version below
```

CI runs all of these on every push to `main` and every pull request
(`.github/workflows/ci.yml`), and again before every release.

Nix flakes only see files git tracks, so a new file needs `jj` or `git add`
to have seen it before `nix flake check` will.

## Tests

Tests are in `test/`, named after what they test: `backup_test.dart`,
`shell_gestures_test.dart`.

- **The rules** are tested in plain Dart, without a phone: search, ranking,
  hints, prefixes, shell gestures, subtasks, synced task lists, backups and
  the rules between settings.
- **The states** are tested against SharedPreferences' in-memory mock, and
  a synced task list against a fake tasks app that keeps its tasks the way
  the provider does (`synced_task_state_test.dart`).
- **Widget tests** pump the settings pages, the drawer, home and the task
  list, and press, hold and drag rows the way a finger does
  (`reorder_by_hold_test.dart`).
- **The Kotlin side** has no tests of its own. `flutter build apk --debug`
  checks that it compiles; what it does needs a phone or an emulator.

Tests and screenshots use made-up apps and tasks only. Anything that could
lose someone's settings, pins or tasks wants a test before it wants a
feature.

A setting renamed or changed in meaning needs a step in
`SettingsState._migrate` and a test that loads the old value; see
[Compatibility](compatibility.md).

## Adding a language

The interface is in English and Dutch, in `lib/l10n/app_<code>.arb`, with
English (`app_en.arb`) as the template. A new string goes into both; then run
`flutter gen-l10n`, and commit the generated `app_localizations*.dart` files
with it.

A language takes:

1. `lib/l10n/app_<code>.arb` with every key from `app_en.arb`.
2. `flutter gen-l10n`, which adds it to the supported languages.
3. `fastlane/metadata/android/<locale>/` with `title.txt`,
   `short_description.txt` and `full_description.txt`, for the store
   listings. Changelogs don't need to be translated.
4. `android/app/src/main/res/values-<code>/strings.xml`, for the few words
   Android shows itself: the accessibility service's description, and the
   question before adding a shortcut.

Ask a native speaker to read it over.

## Releasing

Versions are `MAJOR.MINOR.PATCH+CODE` in `pubspec.yaml`. The code goes up by
one with every release. F-Droid turns it into one code per ABI (`CODE * 10`
plus 1, 2 or 3), in `android/app/build.gradle.kts`.

1. **Write the notes.** Rename `## Unreleased` in `CHANGELOG.md` to the new
   version, and write `fastlane/metadata/android/en-US/changelogs/<CODE>.txt`:
   a short version of the same notes, at most 500 characters, which F-Droid
   and Google Play show. Other languages are optional.
2. **Bump the version** in `pubspec.yaml`, and commit.
3. **Tag it** `v<MAJOR.MINOR.PATCH>` and push the commit and the tag to
   Codeberg. The push mirror brings both to GitHub.
4. **GitHub Actions** (`.github/workflows/release.yml`) checks that the tag
   matches `pubspec.yaml` and that the store notes and the version's part of
   `CHANGELOG.md` exist, and stops if not. Then it runs CI, builds the App
   Bundle and the APKs, signs and attests them, and makes a draft release with
   that part of `CHANGELOG.md` as its notes. A pre-release, tagged like
   `v1.2.0-rc.1`, gets the notes for `1.2.0`.
5. **Publish** the draft on GitHub, and upload `app-release.aab` to Google
   Play.
6. **F-Droid** finds the new tag by itself, and builds and signs its own copy
   from the source.

The upload key is in GitHub's secrets as `KEYSTORE_BASE64`,
`KEYSTORE_PASSWORD` and `KEY_PASSWORD`, with the alias `upload`. Locally,
`android/key.properties` points to it; without that file, a release build is
signed with the debug key.

**F-Droid reads the Flutter version** from the `flutter-version: '…'` line in
`release.yml`, with a `sed` in its build recipe, and runs `flutter pub get
--enforce-lockfile`. So that line, and the ones in `ci.yml`, must be the dev
shell's Flutter, which made `pubspec.lock`; otherwise F-Droid can't build the
release, as happened with 1.3.0. `nix flake check` fails when they differ, and
CI runs `pub get` with the lockfile enforced too. To move to a newer Flutter,
update the flake, run `flutter pub get`, set the new version in both workflows,
and commit them together. Keep the line in `release.yml`, with single quotes.
