# Frequently asked questions

Can't find your answer here? Please
[open an issue](https://codeberg.org/BW20/last-launcher/issues/new/choose).

- [Getting started](#getting-started)
- [Finding apps](#finding-apps)
- [The home screen](#the-home-screen)
- [Double tap to sleep](#double-tap-to-sleep)
- [Work profile](#work-profile)
- [Backups and a new phone](#backups-and-a-new-phone)
- [Installing and updating](#installing-and-updating)

## Getting started

### How do I make Last Launcher my home screen?

Open Last Launcher. If it isn't your home app yet, it offers to become one.
Otherwise, open its settings and choose **Set as default home app**, or go to
your phone's settings, **Apps → Default apps → Home app**. The exact names
differ a little per phone.

### How do I go back to my old launcher?

The same way: **Apps → Default apps → Home app** in your phone's settings, and
pick the old one. Last Launcher keeps your pinned apps and settings, in case
you come back.

### Where are the settings?

Press and hold an empty part of the home screen, next to your apps rather than
on one. You can also tap the gear next to Last Launcher under **Default apps →
Home app** in your phone's settings.

### Can I have icons, widgets or wallpapers?

No. Last Launcher is text on purpose: your apps as words, a search, and
nothing else asking for your attention. If you miss them now and then, your
old launcher is one setting away.

## Finding apps

### An app isn't in the app drawer

Check these in order:

- **Is it pinned?** **Hide pinned apps** is on by default, so apps on your
  home screen don't show up in the drawer a second time.
- **Did you hide it?** Hidden apps are listed under **App drawer → Hidden
  apps** in settings, where you can unhide them. To find them in search too,
  turn on **Include hidden in search**.
- **Is it a work app?** Work apps only show while the work profile is on, see
  [Work profile](#work-profile).
- **Did you rename it?** Search finds it by its new name. With **Match original
  name** on, by its own name too.

### An app didn't open by itself

Last Launcher opens an app once it's the only match for what you typed. It
waits when:

- **Auto-launch on match** is off. In **Search only** drawer mode it's always
  on.
- **Extra character** is on. Then it waits for one more letter.
- Another app still matches, maybe a hidden one with **Include hidden in
  search** on. Turn on **Quick launch hints** to see the fewest letters that
  open each app.

### "Apps starting with these letters can't be found while this is on."

You're setting up a search prefix that starts like some of your apps'
names: with `g` as a web search, typing `g` for Gmail starts a web search
instead. End the prefix with a space (`g `), or start it with a symbol
(`!g`), and both work.

### Does a search prefix send my searches somewhere?

Not by itself. A prefix that opens a link, such as a web search, hands the
link to another app, usually your browser, and that app connects the way it
always does. Last Launcher has no internet permission.

## The home screen

### "Home screen is full"

The home screen holds up to 10 apps, and fewer when they don't fit: with a
large **Text size**, or on a small screen. Unpin one, or make the text a
little smaller under **Appearance**.

### How do I change the order of my apps or tasks?

Press and hold a row, and drag it to its new place. With **Lock layout** on,
that's turned off on the home screen.

### What's on the left and right of home?

A module each, if you want one: **Tasks**, a simple task list, or **Launch
app**, which opens an app of your choice when you swipe that way. Choose them
under **Home → Left module** and **Right module**. The hints on the home screen
say which way to swipe.

## Double tap to sleep

### Why does it need an accessibility service?

Android only lets a launcher lock the screen through an accessibility service.
Last Launcher's does one thing: lock the screen when you double tap the home
screen. It can't read what's on the screen or what you type. The first time
you double tap, Last Launcher explains this and takes you to the system
settings to turn it on. If you'd rather not, turn **Double tap to sleep** off
under **Home**.

It needs Android 9 or newer.

### The switch for the accessibility service is greyed out

Android 13 and newer restrict accessibility services of apps that were
installed from a downloaded APK. Open **Settings → Apps → Last Launcher**, tap
the ⋮ menu at the top, choose **Allow restricted settings**, and try again.
Apps from Google Play, and from F-Droid's app, usually aren't restricted this
way.

## Work profile

### Where are my work apps?

In the app drawer, with your other apps and a small dot in front of them, while
the work profile is on. While it's paused they're left out, and pinned work
apps stay pinned until it's back. The **Work profile** page in
settings, which only shows when you have one, sets how they look.

### Can I search only work apps, or only personal ones?

Start your search with `.` for work apps, or with a space for personal ones.
You can change both under **App drawer → Search prefixes**.

## Backups and a new phone

### How do I move to a new phone?

Under **Backup & restore** in settings, choose **Export backup** and save the
file somewhere you can reach from the new phone. There, install Last Launcher
and choose **Restore backup**. It brings your settings, labels, hidden and
pinned apps, and your tasks if you included them. Android's own backup doesn't
include Last Launcher, so this is the way.

Install your apps on the new phone before you restore: Last Launcher lets go of
pins for apps that aren't installed.

### "This backup is from a newer version of Last Launcher"

Update Last Launcher, and restore again. An older version can't read a backup
from a newer one.

### "This file isn't a Last Launcher backup"

The file you picked isn't one that **Export backup** made, or it was changed
since. Pick the `.json` file you exported.

## Installing and updating

### Can I switch between F-Droid, Google Play and the APK from the releases?

Not without uninstalling first. F-Droid builds and signs Last Launcher
itself, so its copy has a different signature than the one from Google Play or
the releases, and Android won't update one with the other. Export a backup,
uninstall, install from where you want it, and restore.

### Which APK do I need from the releases?

`last-launcher-arm64-v8a.apk` for almost every phone from the last ten years.
`last-launcher-armeabi-v7a.apk` is for older, 32-bit phones. How to check the
file you downloaded is in the README, under
[How releases are built](README.md#94-how-releases-are-built).
