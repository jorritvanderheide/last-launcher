# Last Launcher

## analyze

> Run static analysis

```sh
flutter analyze --fatal-infos
```

## test

> Run all tests

```sh
flutter test
```

## fmt

> Format all files

```sh
nix fmt
```

## fmt-check

> Check formatting without modifying files

```sh
nix flake check
```

## check

> Run fmt, analyze, and tests — use before committing

```sh
nix fmt && flutter analyze --fatal-infos && flutter test
```

## build-apk

> Build release APK

```sh
flutter build apk --release
```
## clean

> Clean build artifacts

```sh
flutter clean
```

## deps

> Get dependencies

```sh
flutter pub get
```

## run

> Run the app in debug mode

```sh
flutter run
```
