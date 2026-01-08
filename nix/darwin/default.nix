{ pkgs, lib, username, ... }:
{
  # =============================================================================
  # This repo is intentionally Nix-first (no Homebrew, no mise).
  # All packages and macOS settings are declared here.
  # =============================================================================

  system.stateVersion = 5;

  services.nix-daemon.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
      options = "--delete-older-than 14d";
    };
  };

  # Shell
  programs.zsh.enable = true;

  # Touch ID for sudo (macOS)
  security.pam.enableSudoTouchIdAuth = true;

  # =============================================================================
  # macOS System Defaults
  # =============================================================================
  system.defaults = {
    NSGlobalDomain = {
      # Keyboard
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 1;
      InitialKeyRepeat = 15;

      # Text
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      # UI
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };

    dock = {
      autohide = true;
      show-recents = false;
      minimize-to-application = true;
      mru-spaces = false;
      tilesize = 48;
      magnification = false;
      launchanim = false;
      orientation = "bottom";
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };

    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
    };

    CustomUserPreferences = {
      # Disable disk image verification
      "com.apple.frameworks.diskimages" = {
        skip-verify = true;
        skip-verify-locked = true;
        skip-verify-remote = true;
      };
    };
  };

  # =============================================================================
  # System Packages (all from Nixpkgs)
  # =============================================================================
  # This replaces both mise and Homebrew formulae.
  # Organized by category matching the former mise config.

  environment.systemPackages = with pkgs; [
    # -------------------------------------------------------------------------
    # Core / Shell
    # -------------------------------------------------------------------------
    git
    git-lfs
    zsh
    bash
    sheldon
    starship

    # -------------------------------------------------------------------------
    # File Operations
    # -------------------------------------------------------------------------
    bat                # cat with syntax highlighting
    eza                # modern ls replacement
    fd                 # fast find alternative
    ripgrep            # fast grep alternative
    fzf                # fuzzy finder
    yazi               # terminal file manager
    zoxide             # smart cd replacement
    tree               # directory tree viewer
    viu                # terminal image viewer

    # -------------------------------------------------------------------------
    # Text Processing
    # -------------------------------------------------------------------------
    jq                 # JSON processor
    sd                 # sed replacement
    choose             # cut replacement
    gnused             # GNU sed

    # -------------------------------------------------------------------------
    # Git Tools
    # -------------------------------------------------------------------------
    gh                 # GitHub CLI
    hub                # GitHub wrapper
    delta              # git diff viewer
    difftastic         # structural diff tool
    lazygit            # Git TUI
    ghq                # Git repository manager
    tig                # Git TUI browser

    # -------------------------------------------------------------------------
    # System Monitoring
    # -------------------------------------------------------------------------
    gping              # ping with graph
    bottom             # htop replacement (btm)
    procs              # ps replacement
    dust               # du replacement
    tokei              # code statistics
    htop               # process viewer

    # -------------------------------------------------------------------------
    # Search & Navigation
    # -------------------------------------------------------------------------
    peco               # interactive filtering
    mcfly              # command history search
    atuin              # shell history manager
    tealdeer           # tldr client (use 'tldr' command)

    # -------------------------------------------------------------------------
    # Development - Editors & Tools
    # -------------------------------------------------------------------------
    neovim             # modern vim
    tmux               # terminal multiplexer
    zellij             # tmux alternative
    just               # command runner
    watchexec          # file watcher
    direnv             # directory-based env
    gnupg              # GPG
    pinentry_mac       # GPG pinentry for macOS
    tree-sitter        # parser generator

    # -------------------------------------------------------------------------
    # Build Tools
    # -------------------------------------------------------------------------
    cmake
    gnumake
    coreutils          # GNU core utilities
    findutils          # GNU find
    gawk               # GNU awk
    libtool
    autoconf
    automake
    pkg-config

    # -------------------------------------------------------------------------
    # Cloud & Infrastructure
    # -------------------------------------------------------------------------
    awscli2            # AWS CLI
    terraform          # Infrastructure as Code
    act                # GitHub Actions locally
    ngrok              # Tunneling
    docker-client      # Docker CLI (requires Docker Desktop)

    # -------------------------------------------------------------------------
    # Databases
    # -------------------------------------------------------------------------
    postgresql_17      # PostgreSQL
    mysql84            # MySQL client
    sqlite             # SQLite

    # -------------------------------------------------------------------------
    # Media Processing
    # -------------------------------------------------------------------------
    ffmpeg             # media processing
    imagemagick        # image manipulation
    resvg              # SVG rendering

    # -------------------------------------------------------------------------
    # Code Quality & Linting
    # -------------------------------------------------------------------------
    biome              # formatter & linter
    buf                # Protocol Buffers tool

    # -------------------------------------------------------------------------
    # Networking
    # -------------------------------------------------------------------------
    curl
    wget
    tor                # Tor network
    aria2              # download utility

    # -------------------------------------------------------------------------
    # Compression
    # -------------------------------------------------------------------------
    p7zip              # 7z
    xz
    zstd
    lz4
    lzo

    # -------------------------------------------------------------------------
    # Security
    # -------------------------------------------------------------------------
    _1password-cli     # 1Password CLI (op)
    openssl

    # -------------------------------------------------------------------------
    # Misc CLI Tools
    # -------------------------------------------------------------------------
    hyperfine          # benchmarking tool
    neofetch           # system info
    chromedriver       # ChromeDriver
    mas                # Mac App Store CLI

    # -------------------------------------------------------------------------
    # Language Runtimes (replacing mise)
    # -------------------------------------------------------------------------
    nodejs_22          # Node.js LTS
    python313          # Python 3.13
    uv                 # Fast Python package manager
    ruby_3_3           # Ruby
    go                 # Go
    temurin-bin-21     # Java (Eclipse Temurin JDK 21)
    bun                # Bun runtime
    deno               # Deno runtime

    # -------------------------------------------------------------------------
    # Node.js Global Tools (as Nix packages where available)
    # -------------------------------------------------------------------------
    # serverless, aws-cdk, cdktf-cli → use npx or install via npm globally

    # -------------------------------------------------------------------------
    # Python Tools
    # -------------------------------------------------------------------------
    # cfn-lint, git-remote-codecommit, snowflake-cli → install via uv/pipx

    # -------------------------------------------------------------------------
    # Fonts
    # -------------------------------------------------------------------------
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "JetBrainsMono" "FiraCode" ]; })

    # -------------------------------------------------------------------------
    # Libraries (some Homebrew formulae were deps, Nix handles automatically)
    # But we explicitly add commonly needed ones
    # -------------------------------------------------------------------------
    openexr
    libheif
    libyaml
    libgit2
    libsodium
    protobuf
    zeromq
  ];

  # =============================================================================
  # GUI Applications
  # =============================================================================
  # Since we're not using Homebrew, GUI apps need manual installation.
  # Listed here for documentation. Install from:
  # - Mac App Store (use `mas` CLI)
  # - Direct download from vendor
  #
  # Recommended GUI apps (former Homebrew casks):
  # - 1password        → Mac App Store or https://1password.com
  # - alfred           → https://www.alfredapp.com
  # - appcleaner       → https://freemacsoft.net/appcleaner/
  # - arc              → https://arc.net
  # - chatgpt          → Mac App Store
  # - cursor           → https://cursor.sh
  # - discord          → https://discord.com
  # - docker-desktop   → https://www.docker.com/products/docker-desktop
  # - ghostty          → https://ghostty.org
  # - google-chrome    → https://www.google.com/chrome/
  # - google-japanese-ime → https://www.google.co.jp/ime/
  # - messenger        → Mac App Store
  # - monitorcontrol   → https://github.com/MonitorControl/MonitorControl
  # - ngrok            → (CLI installed via Nix, GUI optional)
  # - signal           → https://signal.org
  # - slack            → Mac App Store or https://slack.com
  # - spark-app        → Mac App Store (Spark email)
  # - spectacle        → https://www.spectacleapp.com (or use Rectangle)
  # - telegram         → Mac App Store
  # - visual-studio-code → https://code.visualstudio.com
  # - wezterm          → https://wezfurlong.org/wezterm/
  # - zoom             → https://zoom.us

  # =============================================================================
  # Environment Variables
  # =============================================================================
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # =============================================================================
  # Activation Scripts (for settings not covered by system.defaults)
  # =============================================================================
  system.activationScripts.postUserActivation.text = ''
    # Create Screenshots directory
    mkdir -p "$HOME/Pictures/Screenshots"

    # Show ~/Library folder
    chflags nohidden ~/Library

    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

    # Disable "Are you sure you want to open this application?" dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Enable full keyboard access for all controls (Tab in dialogs)
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Finder: show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Finder: disable window animations
    defaults write com.apple.finder DisableAllAnimations -bool true

    # Safari: Enable developer menu
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  '';
}
