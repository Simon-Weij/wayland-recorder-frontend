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
      devShell = {
        packages = pkgs: [
          pkgs.flutter
          wayland-recorder.packages.${pkgs.system}.default
          pkgs.gst_all_1.gstreamer
          pkgs.gst_all_1.gst-plugins-base
          pkgs.gst_all_1.gst-plugins-good
          pkgs.gst_all_1.gst-plugins-bad
          pkgs.gst_all_1.gst-plugins-ugly
        ];
        env = pkgs: {
          GST_PLUGIN_SYSTEM_PATH_1_0 = pkgs.lib.makeSearchPath "lib/gstreamer-1.0" [
            pkgs.gst_all_1.gstreamer
            pkgs.gst_all_1.gst-plugins-base
            pkgs.gst_all_1.gst-plugins-good
            pkgs.gst_all_1.gst-plugins-bad
            pkgs.gst_all_1.gst-plugins-ugly
          ];
        };
      };
    };
}
