{
  description = "Last Launcher";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      androidSdk = androidComposition.androidsdk;
      system = "x86_64-linux";
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [ "35.0.0" ];
        cmakeVersions = [ "3.22.1" ];
        includeEmulator = false;
        includeNDK = true;
        includeSources = false;
        includeSystemImages = false;
        ndkVersions = [ "28.2.13676358" ];

        platformVersions = [
          "34"
          "35"
          "36"
        ];
      };

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
    in
    {
      checks.${system}.formatting = treefmtEval.config.build.check self;
      formatter.${system} = treefmtEval.config.build.wrapper;

      devShells.${system}.default = pkgs.mkShell {
        ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/35.0.0/aapt2";
        JAVA_HOME = "${pkgs.jdk21}";

        buildInputs = with pkgs; [
          androidSdk
          dart
          flutter
          gradle
          jdk21
          mask
          treefmtEval.config.build.wrapper
        ];

        shellHook = ''
          echo "Last Launcher dev shell"
        '';
      };
    };
}
