# Security policy

## Supported versions

Security fixes go into the latest release of Last Launcher. Older releases
don't get separate fixes, so please update before you report.

## Reporting a problem

Please don't open a public issue for a security problem. Codeberg, where the
issues are, has no private reports, so report it privately through the GitHub
mirror instead:

https://github.com/jorritvanderheide/last-launcher/security/advisories/new

Include the Last Launcher version (Settings → About), where you got it
(F-Droid, Google Play, a release APK or your own build), your phone and
Android version, and the steps to reproduce it. Reports are looked at before
anything about them is made public.

## What counts

Last Launcher has no internet permission and connects to nothing. It lists
and opens your apps, keeps its settings and tasks on your phone, and uses an
accessibility service for one thing only: locking the screen when you double
tap. See
[section 9 of the README](README.md#9-permissions-and-data-disclosure).

So these are security problems:

- Last Launcher connecting to anything, or anything you stored in it leaving
  your phone without you exporting it.
- The accessibility service doing anything besides locking the screen, such
  as reading what's on the screen or what you type.
- A backup file that does more than set the settings, labels, apps and tasks
  in it, such as making the launcher open an app or a link by itself.
- Another app reading what Last Launcher stores, or making it do something
  you didn't ask for.

A bug that loses your pinned apps, labels or tasks is serious too, but it isn't
secret: please report that as a normal issue, so others can see it.
