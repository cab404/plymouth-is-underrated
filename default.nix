{
  pkgs ? import <nixpkgs> {},
  theme ? "evil-nixos",
  overrides ? {},
}: pkgs.runCommand "nixos-boot" {} ''

    install -Dt $out/share/plymouth/themes/${theme} ${./themes/${theme}}/*
    
    cd $out/share/plymouth/themes/${theme}

    ${
    with builtins; (
      concatStringsSep "\n" (map (name: ''
        sed -i "s|@${name}@|${overrides.${name}}|g" ${theme}.plymouth
      '') (attrNames overrides))
    )
    }
    
    sed -i "s|@@|$out/share/plymouth/themes/${theme}|g" ${theme}.plymouth

    sed -i "s|@PLYMOUTH_THEME_PATH@|$out/share/plymouth/themes/${theme}|g" ${theme}.plymouth

    chmod +x *.plymouth *.script

''
