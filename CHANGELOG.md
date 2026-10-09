# Changelog

What changed in each release of Last Launcher, newest first. What counts as
breaking is in [Compatibility](docs/compatibility.md). The stores show a
shorter version of the same notes, from `fastlane/metadata/android/`.

## 1.3.1

- On F-Droid, this is the first release since 1.2.1: F-Droid couldn't build
  1.3.0, so everything listed under 1.3.0 is new there too.
- Help, in settings, opens the answers to common questions instead of the
  project page.

## 1.3.0

- Settings are split into pages: Appearance, Home, App drawer, a page for
  each module you use, Work profile, and Backup & restore.
- Backup & restore saves your settings, labels, hidden and pinned apps to a
  file, and your tasks if you want them too. Restore it on the same phone or
  a new one.
- The look is made of separate options: font, text size, text alignment,
  Accent color from your system's colours, glow, scanlines, a terminal prompt
  and animations. Extra is now a Style that turns on the retro ones together,
  and if you used the Extra theme, you keep it.
- Drawer mode is List or Search only, instead of a search-only switch, and
  Extra character works in Search only too.
- A new module, Launch app, opens an app of your choice when you swipe to its
  side.
- Search prefixes: type a prefix and a search to open a link, such as a web
  search or a map, or to search in an app. Set them up under App drawer.
  The prefixes for work and personal apps only show with a work profile.
- Shortcuts you add from other apps, such as a website you install as an app
  from your browser, are listed with your apps.
- Press and hold a row on home or in the task list to drag it to a new place.
- Pressing the home button takes you back to the home page.
- The keyboard no longer flickers.
- Pinned work apps stay pinned while the work profile is paused.
- A setting stored by another version of Last Launcher can't make it crash
  any more; the setting goes back to its default instead.

## 1.2.1

- Extra character waits for one more letter after only one app matches,
  before it launches it.
- Search, quick launch hints and the order of results are steadier.

## 1.2.0

- Work profile: work apps are listed with your other apps, with a dot in
  front of them, and can be pinned. The Work profile page in settings sets
  how they show.
- Quick launch hints show as you type.
- Search results are sorted by name and by how short their hint is.

## 1.1.0

- Quick launch hints mark the fewest letters that launch each app. They use
  letters only, follow Match original name, and aren't held back by a hidden
  app with the same name.
- Double tap to sleep: double tap the home screen to lock your phone. It uses
  an accessibility service that does nothing else. It's on by default, and the
  first double tap explains it before sending you to the system settings to
  turn it on.
- The sides of home are called the left and right module.

## 1.0.6

- Last Launcher offers to become your default home app when it isn't, and
  Set as default home app in settings opens the system's picker.
- Fullscreen hides the status bar reliably.
- Search and sorting ignore accents, so "e" finds "é".
- Pins, labels and hidden apps of apps you uninstalled are cleared.

## 1.0.5

- The hints on home say which side each module is on.

## 1.0.4

- Choose what's on the left and right of home.
- Settings are grouped under Appearance, Home, App drawer and Modules.
- Search ranks apps that start with what you typed first.
- Settings has Rate, Send feedback and Help.
- Clear completed daily removes done tasks at the end of the day.
- Tapping near a drag handle no longer launches the app.

## 1.0.3

- The task list is redesigned: tap a task to rename it, tick it off with its
  checkbox, and drag it by its handle after a long press. Done tasks are
  ordered on their own.
- Match original name finds an app you renamed by its own name too.
- Lock layout turns off long press on the home screen and in the task list.
- Settings are grouped under General, App drawer and Tasks.
- A hidden app that's pinned shows dimmed when Include hidden in search is on.

## 1.0.2

- Hide pinned apps leaves your pinned apps out of the app drawer.
- Include hidden in search lets search find hidden apps too.
- The gear next to Last Launcher in Android's default apps settings opens its
  settings.
- Screen readers name every button, focus is visible, contrast is higher, and
  animations follow the system's setting to reduce motion.
- The keyboard shows again when you come back to the app drawer from an app.

## 1.0.1

- Press and hold an app for App info.
- Every row of actions that a long press opens has an X to close it.
- The task list's hints tell an empty list apart from a search without
  matches.
- Switches you can't use right now are dimmed.
- One Show hints switch for the whole app, and icons for each section of
  settings.

## 1.0.0

The first release: your apps as text, a search that launches an app as soon
as it's the only match, a task list a swipe away, and the System, Light, Dark
and Extra themes.
