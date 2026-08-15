{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
     inputs.zen-browser.homeModules.twilight
     inputs.noctalia.homeModules.default
  ];

  home = {
    username = "lunomeu";
    homeDirectory = "/home/lunomeu";
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "0LucasMatheus";
    userEmail = "lucasmatheus5305@gmail.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = import ./zsh {inherit pkgs lib;};

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
  };

  programs.bat.enable = true;

  xdg.terminal-exec = {
    enable = true;
    settings.default = ["kitty.desktop"];
  };

  gtk = {
    enable = true;
    font.name = "DepartureMono Nerd Font";
    font.size = 14;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
      font_family = "DepartureMono Nerd Font";
      font_size = "16";
      background_opacity = "0.85";
    };
    extraConfig = ''
      include themes/noctalia.conf
    '';
  };

   programs.vscodium.enable = true;

   programs.zen-browser = {
     enable = true;
     setAsDefaultBrowser = true;
     profiles.default.settings = {
       "browser.startup.page" = 1;
       "browser.sessionstore.resume_from_crash" = false;
     };
   };

   programs.noctalia = {
     enable = true;
     systemd.enable = true;
     settings = ./noctalia/settings.toml;
   };

  home.packages = with pkgs; [
    btop
    nano
    nautilus
    papirus-icon-theme
    imv
    mpv
    ffmpeg
    ntfs3g
    poppler-utils
    exiftool
    fd
    glib
    gnumake
    nerd-fonts.meslo-lg
    nerd-fonts._0xproto
    nerd-fonts.departure-mono
    fastfetch
    krabby
    devenv
    anydesk
    fuzzel
    unstable.claude-code
    wl-clipboard
    xwayland-satellite
    grim
    slurp
    satty
  ];

  home.pointerCursor = {
    package = pkgs.cartoonish-bold-cursor;
    name = "Cartoonish-Bold";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

  home.file.".p10k.zsh".source = ./zsh/p10k.zsh;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };


  home.stateVersion = "26.05";
}
