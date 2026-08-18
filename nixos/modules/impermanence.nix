{...}: {
  boot.initrd.systemd.enable = true;

  boot.initrd.systemd.services.rollback = {
    description = "Rollback btrfs @ para estado limpo";
    wantedBy = ["initrd.target"];
    after = ["systemd-cryptsetup@cryptroot.service"];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /btrfs_tmp
      mount /dev/mapper/cryptroot /btrfs_tmp

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for subvol in @; do
        if [[ -e "/btrfs_tmp/$subvol" ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y "/btrfs_tmp/$subvol")" "+%Y-%m-%-d_%H:%M:%S")
            mv "/btrfs_tmp/$subvol" "/btrfs_tmp/old_roots/''${subvol}_''${timestamp}"
        fi
      done

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +7 2>/dev/null); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume snapshot /btrfs_tmp/@blank /btrfs_tmp/@

      umount /btrfs_tmp
    '';
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    directories = [
      "/var/lib/nixos"
      "/var/log"
      "/var/cache"
      "/var/db/sudo"
      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
    ];
    users.lunomeu = {
      directories = [
        ".zen"
        ".anydesk"
        ".config/VSCodium"
        ".vscode-oss"
        ".claude"
        ".config/nirimod"
        ".config/obs-studio"
        ".local/state/noctalia"
        ".local/share/vscode-vibrancy"
        ".config/vscode-vibrancy-continued"
        "Downloads"
        "Documents"
        "nix"
        "Projects"
        "Templates"
        "Pictures"
        "Music"
        "Videos"
      ];
      files = [
        ".claude.json"
        ".config/mimeapps.list"
        ".zsh_history"
        ".config/niri/noctalia.kdl"
        ".local/share/applications/code-vibrancy.desktop"
        ".local/share/applications/codium.desktop"
        ".config/dolphinrc"
        ".config/fastfetch/config.jsonc"
        ".local/share/user-places.xbel"
      ];
    };
  };
}
