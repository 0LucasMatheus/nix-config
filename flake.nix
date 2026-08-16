{
  description = "NixOS - niri + noctalia + impermanencia total (btrfs)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

     niri.url = "github:sodiboo/niri-flake";
     niri.inputs.nixpkgs.follows = "nixpkgs";

     noctalia = {
       url = "github:noctalia-dev/noctalia";
       inputs.nixpkgs.follows = "nixpkgs";
     };

     zen-browser = {
       url = "github:0xc000022070/zen-browser-flake";
       inputs.nixpkgs.follows = "nixpkgs-unstable";
       inputs.home-manager.follows = "home-manager";
     };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
     niri,
     noctalia,
     zen-browser,
    ...
  } @ inputs: let
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      nixos999 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/configuration.nix
          impermanence.nixosModules.impermanence
          niri.nixosModules.niri
          noctalia.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
