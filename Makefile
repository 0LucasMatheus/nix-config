.PHONY: help switch boot build update check fmt gc

help:
	@echo "make switch  - aplica a config agora (sudo nixos-rebuild switch)"
	@echo "make boot    - aplica so no proximo boot (sudo nixos-rebuild boot)"
	@echo "make build   - so builda, sem aplicar, sem sudo (teste rapido)"
	@echo "make update  - atualiza os inputs do flake (nix flake update)"
	@echo "make check   - valida o flake (nix flake check)"
	@echo "make fmt     - formata os arquivos .nix (nix fmt)"
	@echo "make gc      - remove geracoes de sistema com mais de 7 dias (sudo, tambem roda sozinho toda semana)"

switch:
	sudo nixos-rebuild switch --flake .

boot:
	sudo nixos-rebuild boot --flake .

build:
	nixos-rebuild build --flake .

update:
	nix flake update

check:
	nix flake check

fmt:
	nix fmt

gc:
	sudo nix-collect-garbage --delete-older-than 7d
