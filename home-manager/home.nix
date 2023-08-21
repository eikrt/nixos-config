{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };
  home = {
    username = "eino";
    homeDirectory = "/home/eino";
    keyboard.layout = "fi";
    packages = with pkgs; [ cowsay vim retroarch firefox icewm arandr pavucontrol sway wayfire mate.mate-terminal];

    file.".emacs.d" = {
      recursive = true;
	    source = pkgs.fetchFromGitHub {
	      owner = "eikrt";
	      repo = "emacs.d";
	      rev = "b9623be32a9fad0683f8ccaa1e5af887de0a85dd";
	      sha256 = "1cjnn4c38v2cqagail7xiz30xzv5qjfr9472zqwb9yfl6521kaw5";
	    };
   	};

  };
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        hs = "home-manager switch --flake .#eino@nixos";
        ns = "sudo nixos-rebuild switch --flake .#nixos";
      };
      bashrcExtra = "export NIX_CONFIG='experimental-features = nix-command flakes'";
    };
    git = {
      enable = true;
      userName = "Eino Korte";
      userEmail = "e.i.korte@gmail.com";
    };
	  emacs = {
      enable = true;
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "mate-terminal"; 
      startup = [
      ];
      input = {"*" = {xkb_layout= "fi";}; }; 
    };
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
