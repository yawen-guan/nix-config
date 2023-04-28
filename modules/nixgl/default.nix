# Why do we need nixGL? See: https://github.com/guibou/nixGL
# Example: https://www.reddit.com/r/NixOS/comments/ip1w1y/anyone_else_has_problems_with_kitty/
{
  pkgs,
  lib,
  ...
}: pkg:
pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
  mkdir $out
  ln -s ${pkg}/* $out
  rm $out/bin
  mkdir $out/bin
  for bin in ${pkg}/bin/*; do
    wrapped_bin=$out/bin/$(basename $bin)
    echo "exec ${lib.getExe pkgs.nixgl.auto.nixGLDefault} $bin \"\$@\"" > $wrapped_bin
    chmod +x $wrapped_bin
  done
''