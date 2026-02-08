{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    wayland-recorder.url = "github:simon-weij/wayland-recorder";
  };
  outputs = {
    flakelight,
    wayland-recorder,
    ...
  }:
    flakelight ./. {
      package = {
        flutter,
        lib,
        ...
      }:
        flutter.buildFlutterApplication {
          pname = "wayland-recorder-frontend";
          version = "1.0.0";
          src = ./.;
          autoPubspecLock = ./pubspec.lock;
        };
      devShell.packages = pkgs: [pkgs.flutter wayland-recorder.packages.${pkgs.system}.default];
    };
}
