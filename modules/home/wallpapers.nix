{
  lib,
  ...
}:
let
  wallpaperDir = ../../assets/wallpapers;

  # Any image dropped into ./assets/wallpapers is installed to
  # ~/Pictures/Wallpapers, where Serpantinum's wallpaper picker looks.
  images = lib.filterAttrs (
    name: type:
    type == "regular"
    && (
      lib.hasSuffix ".png" name
      || lib.hasSuffix ".jpg" name
      || lib.hasSuffix ".jpeg" name
      || lib.hasSuffix ".webp" name
    )
  ) (builtins.readDir wallpaperDir);
in
{
  home.file = lib.mapAttrs' (
    name: _:
    lib.nameValuePair "Pictures/Wallpapers/${name}" {
      source = wallpaperDir + "/${name}";
    }
  ) images;
}
