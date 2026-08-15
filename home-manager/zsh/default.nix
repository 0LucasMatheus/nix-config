{
  pkgs,
  lib,
}: {
  enable = true;
  shellAliases = {
    pokefetch = "krabby random | fastfetch --file-raw -";
  };
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  historySubstringSearch.enable = true;
  history = {
    size = 50000;
    save = 50000;
    share = true;
    extended = true;
    ignoreAllDups = true;
  };
  plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
  ];
  initContent = lib.mkMerge [
    (lib.mkOrder 500 ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '')
    (lib.mkOrder 560 ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '')
    (lib.mkOrder 1000 ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '')
  ];
}
