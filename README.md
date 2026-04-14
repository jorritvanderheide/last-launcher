# Last Launcher

**The last launcher you'll ever need.**

A minimal, text-only Android launcher built for speed and zero distractions. No icons, no widgets, no clutter — just your apps as plain text.

[![Donate](https://liberapay.com/assets/widgets/donate.svg)](https://liberapay.com/BW20)

## Features

- **Fastest way to open apps** — swipe up, type a few letters, auto-launches on match
- **Keyboard-first** — keyboard opens automatically, search filters in real time
- **Zero distractions** — search-only mode hides everything until you type
- **Built-in task list** — swipe right for a simple task list with search and reorder
- **Pure black AMOLED** — true black in dark mode, easy on the eyes and battery
- **Retro theme** — optional CRT scanlines, glitch effects, monospace font, and neon glow
- **14 languages** — English, Dutch, German, French, Spanish, and more

## Privacy

Last Launcher makes zero network calls. Everything stays on your device.

- No accounts, no analytics, no telemetry, no ads
- No internet permission required
- No Google Play Services required
- Works on privacy-focused ROMs (GrapheneOS, CalyxOS, LineageOS)

## Building from source

Requires [Nix](https://nixos.org/) with flakes enabled:

```sh
nix develop          # enter dev shell
flutter pub get      # fetch dependencies
flutter run          # run in debug mode
mask check           # format, analyze, and test
```

## Tech stack

- Flutter (Android only)
- SharedPreferences for persistence
- Platform channels for app listing and launch intents

## License

[EUPL 1.2](LICENSE), open source and copyleft.
