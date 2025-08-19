{ pkgs }:

with pkgs; [
  # AI & LLM Tools
  claude-code
  fabric-ai
  ollama
  shell-gpt

  # Containers, Kubernetes & VMs
  colima
  docker
  docker-compose
  kube3d
  kubectl
  kubectx
  kubernetes-helm
  lazydocker
  lima
  minikube
  stern

  # Databases
  sqlite

  # Development Tools
  ctags
  goreleaser
  graphviz
  heroku
  (
    google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ])
  )

  # Editors & IDEs
  lunarvim
  neovim
  vscode

  # Fonts
  dejavu_fonts
  font-awesome
  hack-font
  jetbrains-mono
  meslo-lgs-nf
  noto-fonts
  noto-fonts-emoji

  # Git & VCS
  gh
  git
  git-lfs
  gitleaks
  gitsign
  lazygit
  lefthook
  soft-serve
  tig

  # Languages & Toolchains
  go_1_23
  golint
  gopls
  jdk8
  nodejs_24
  python313Packages.nbdime
  rustup

  # Mobile Development
  cocoapods

  # Networking
  dnsmasq
  iftop
  ipcalc
  nssTools
  openssh

  # Nix & Dev Environment
  any-nix-shell
  devbox
  direnv
  lorri
  nixfmt-rfc-style

  # Python Tooling
  pipx
  uv
  virtualenv

  # Security & Cryptography
  age
  age-plugin-yubikey
  cosign
  gnupg
  keychain
  libfido2
  mkcert
  pinentry-curses
  pinentry_mac
  sops
  yubikey-manager
  yubikey-personalization

  # Shells & Terminals
  alacritty
  fish
  sesh
  starship
  tmux
  tmuxp
  zellij
  zsh-powerlevel10k

  # Shell Navigation
  jump
  zoxide

  # System & Monitoring
  btop
  htop
  neofetch

  # Media & GUI
  ffmpeg
  iina
  spotify

  # CLI Utilities
  aria2
  bash-completion
  bat
  coreutils
  crush
  dua
  eza
  fd
  fpp
  fzf
  glow
  gum
  httpie
  jc
  jq
  nix-prefetch-git
  pet
  pika
  ripgrep
  shfmt
  silver-searcher
  skim
  stow
  tldr
  tree
  unrar
  unzip
  watch
  wget
  zip
]
