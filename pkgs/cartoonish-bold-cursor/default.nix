{runCommand}:
runCommand "cartoonish-bold-cursor" {} ''
  mkdir -p $out/share/icons/Cartoonish-Bold
  cp -r ${./cursors} $out/share/icons/Cartoonish-Bold/cursors
  cp ${./index.theme} $out/share/icons/Cartoonish-Bold/index.theme
  cp ${./readme.txt} $out/share/icons/Cartoonish-Bold/readme.txt
''
