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

## Tests

Tests are in `test/`, named after what they test: `backup_test.dart`,
`shell_gestures_test.dart`. Most test the pure rules (search, ranking, hints,
prefixes, gestures, backups and settings) without a device. Widget tests
cover the settings screens and the drawer. Tests use made-up apps and tasks
only.

A setting renamed or changed in meaning needs a step in
`SettingsState._migrate` and a test that loads the old value; see
[Compatibility](compatibility.md).

## Translations

The interface strings are in `lib/l10n/app_<code>.arb`, with English
(`app_en.arb`) as the template. After changing one, run `flutter gen-l10n` and
commit the generated `app_localizations*.dart` files with it.

Adding a language takes:

1. `lib/l10n/app_<code>.arb` with every key from `app_en.arb`.
2. `flutter gen-l10n`, which adds it to the supported languages.
3. `fastlane/metadata/android/<locale>/` with `title.txt`,
   `short_description.txt`, `full_description.txt` and the changelogs, for
   the store listings.

Ask a native speaker to read it over.

## Releases

Versions are `MAJOR.MINOR.PATCH+CODE` in `pubspec.yaml`. The code goes up by
one with every release. F-Droid turns it into one code per ABI (`CODE * 10`
plus 1, 2 or 3), in `android/app/build.gradle.kts`.

1. **Write the notes.** Rename `## Unreleased` in `CHANGELOG.md` to the new
   version, and write `fastlane/metadata/android/<locale>/changelogs/<CODE>.txt`
   for every locale: a short version of the same notes, at most 500
   characters, which F-Droid and Google Play show.
2. **Bump the version** in `pubspec.yaml`, and commit.
3. **Tag it** `v<MAJOR.MINOR.PATCH>` and push the commit and the tag to
   Codeberg. The push mirror brings both to GitHub.
4. **GitHub Actions** (`.github/workflows/release.yml`) checks that the tag
   matches `pubspec.yaml` and that the store notes exist, runs CI, builds the
   App Bundle and the APKs, signs and attests them, and makes a draft release
   with the version's part of `CHANGELOG.md` as its notes.
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
