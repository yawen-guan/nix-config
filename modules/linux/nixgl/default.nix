# Why do we need nixGL? See: https://github.com/guibou/nixGL
# Example: https://www.reddit.com/r/NixOS/comments/ip1w1y/anyone_else_has_problems_with_kitty/

# echo "exec ${lib.getExe pkgs.nixgl.auto.nixGLDefault} $bin \"\$@\"" > $wrapped_bin
# triggers the warning "warning: getExe: Package nixGL does not have the meta.mainProgram attribute.
# We'll assume that the main program has the same name for now, but this behavior is deprecated, because 
# it leads to surprising errors when the assumption does not hold. If the package has a main program, 
# please set `meta.mainProgram` in its definition to make this warning go away. Otherwise, if the package 
# does not have a main program, or if you don't control its definition, use getExe' to specify the name 
# to the program, such as lib.getExe' foo "bar"."

{ pkgs, lib, ... }: pkg:
pkgs.runCommand "${pkg.name}-nixgl-wrapper" { } ''
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
