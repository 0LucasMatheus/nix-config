{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules/impermanence.nix
    ./modules/desktop.nix
    ./modules/services.nix
    ./modules/home-manager.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
    };
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  time.timeZone = "America/Sao_Paulo";

  networking.hostName = "nixos999";

  users.users.lunomeu = {
    initialHashedPassword = "$6$bh.JcP9f8I1.61fR$PRfOEOad0bvpjjm5E05SVRzac4wratdtGyipBQ6DsHDCIbFHnCVnlMwgeYgXaD7KpsF8AZCeVly/DFzVTvq890";
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video"];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  programs.nix-ld.enable = true;

  system.stateVersion = "26.05";
}
