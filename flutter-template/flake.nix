{
  description = "Flutter FHS environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          android_sdk.accept_license = true;
        };

        androidEnv = pkgs.androidenv.override {licenseAccepted = true;};

        androidComposition = androidEnv.composeAndroidPackages {
          cmdLineToolsVersion = "8.0";
          platformToolsVersion = "34.0.4";
          buildToolsVersions = [
            "30.0.3"
            "33.0.2"
            "34.0.0"
          ];
          platformVersions = [
            "28"
            "31"
            "32"
            "33"
            "34"
            "35"
          ];
          abiVersions = ["x86_64"];
          includeNDK = true;
          ndkVersions = ["26.3.11579264" "28.1.13356709" "27.0.12077973" "25.1.8937393"];
          includeSystemImages = true;
          systemImageTypes = [
            "google_apis"
            "google_apis_playstore"
          ];
          includeEmulator = true;
          useGoogleAPIs = true;
          extraLicenses = [
            "android-googletv-license"
            "android-sdk-arm-dbt-license"
            "android-sdk-license"
            "android-sdk-preview-license"
            "google-gdk-license"
            "intel-android-extra-license"
            "intel-android-sysimage-license"
            "mips-android-sysimage-license"
          ];
        };

        androidSdk = androidComposition.androidsdk;

        fhs = pkgs.buildFHSEnv {
          name = "fhs";

          targetPkgs = pkgs:
            with pkgs; [
              androidSdk
              flutter
              qemu_kvm
              gradle
              jdk17
              google-chrome
              vulkan-loader
              libGL
              mesa-demos
              fish
            ];

          # Runs every time you enter the env
          profile = ''
            if [ -d "$HOME/android-sdk" ]; then
              rm -rf "$HOME/android-sdk"
              cp -rL --no-preserve=ownership "${androidSdk}/libexec/android-sdk" "$HOME/android-sdk"
              chmod -R u+rw "$HOME/android-sdk"
              export ANDROID_HOME="$HOME/android-sdk"
              export ANDROID_SDK_ROOT="$HOME/android-sdk"
            else
              cp -rL --no-preserve=ownership "${androidSdk}/libexec/android-sdk" "$HOME/android-sdk"
              chmod -R u+rw "$HOME/android-sdk"
              export ANDROID_HOME="$HOME/android-sdk"
              export ANDROID_SDK_ROOT="$HOME/android-sdk"
            fi

            export JAVA_HOME="${pkgs.jdk17.home}"
            export CHROME_EXECUTABLE="${pkgs.google-chrome}/bin/google-chrome-stable"
            export FLUTTER_ROOT="${pkgs.flutter}"
            export DART_ROOT="${pkgs.flutter}/bin/cache/dart-sdk"
            export GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/33.0.2/aapt2"
            export QT_QPA_PLATFORM="wayland;xcb"
            export LD_LIBRARY_PATH="${
              pkgs.lib.makeLibraryPath [
                pkgs.vulkan-loader
                pkgs.libGL
              ]
            }:$LD_LIBRARY_PATH"

            # Add Dart pub global binaries to PATH
            if [ -n "$PUB_CACHE" ]; then
              export PATH="$PATH:$PUB_CACHE/bin"
            else
              export PATH="$PATH:$HOME/.pub-cache/bin"
            fi
          '';

          runScript = "fish";
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [fhs];
        };

        shellHook = ''
          echo "You are entering to a nix flutter environment, hurray"
          fhs
        '';
      }
    );
}

