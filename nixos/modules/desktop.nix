{
  inputs,
  pkgs,
  ...
}: let
  sddmAstronautCustom = pkgs.runCommand "sddm-astronaut-theme-custom" {} ''
    cp -r ${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme $out
    chmod -R u+w $out
    cp ${./sddm/jake.mp4} $out/Backgrounds/jake.mp4
    sed -i 's|^Background=.*|Background="Backgrounds/jake.mp4"|' $out/Themes/astronaut.conf
    sed -i 's|^FormPosition=.*|FormPosition="right"|' $out/Themes/astronaut.conf
  '';
in {
  environment.systemPackages = with pkgs; [
    brightnessctl
    kdePackages.breeze
    kdePackages.dolphin
    kdePackages.kio-admin
    kdePackages.qtsvg
    teamviewer    
  ];

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  services.udev.packages = with pkgs; [brightnessctl];

  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
  };
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  # o niri-flake liga um agent de polkit generico (KDE) por padrao;
  # desliga pra deixar o agent personalizado do noctalia registrar sozinho
  systemd.user.services.niri-flake-polkit.enable = false;

  ## inicializador de sessao
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
    theme = "${sddmAstronautCustom}";
    extraPackages = [pkgs.sddm-astronaut];
    settings.Theme = {
      CursorTheme = "breeze_cursors";
      CursorSize = 24;
    };
  };

  systemd.services.display-manager.environment = {
    XCURSOR_THEME = "breeze_cursors";
    XCURSOR_SIZE = "24";
    XCURSOR_PATH = "/run/current-system/sw/share/icons";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
