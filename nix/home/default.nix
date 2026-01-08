{ self, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # Update this only when Home Manager asks you to.
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  xdg.enable = true;

  # Root dotfiles
  home.file.".zshenv".source = "${self}/.zshenv";
  home.file.".zshrc".source = "${self}/.zshrc";
  home.file.".zprofile".source = "${self}/.zprofile";
  home.file.".gitconfig".source = "${self}/.gitconfig";

  # XDG configs (symlinked from this repo)
  xdg.configFile."zsh".source = "${self}/.config/zsh";
  xdg.configFile."sheldon".source = "${self}/.config/sheldon";
  xdg.configFile."nvim".source = "${self}/.config/nvim";
  xdg.configFile."wezterm".source = "${self}/.config/wezterm";
  xdg.configFile."karabiner".source = "${self}/.config/karabiner";

  # Starship is a single file under ~/.config
  xdg.configFile."starship.toml".source = "${self}/.config/starship.toml";

  # This repo currently stores Ghostty config under `.config/ghostty/`.
  # Keep that path for compatibility.
  xdg.configFile."ghostty".source = "${self}/.config/ghostty";
}
