{pkgs}:
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
  code-cursor
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
  soft-serve
  tig

  # Languages & Toolchains
  cargo
  go_1_23
  jdk8
  nodejs_24
  python313Packages.nbdime
  rustc
  terraform # Required for terraform_fmt formatter

  # LaTeX & Document Processing
  pandoc # Universal document converter
  tectonic # Modern LaTeX engine (for render-markdown)
  texlive.combined.scheme-medium # LaTeX distribution

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
  deadnix # Detect unused Nix code (not in Mason)
  devbox
  direnv
  nixpkgs-fmt # Nix formatter (required for conform.nvim)
  statix # Nix static analysis (not in Mason)

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
  mitmproxy
  wireshark-qt

  # Media & GUI
  ffmpeg
  ghostscript # For PDF rendering in Snacks
  imagemagick # For image processing in Snacks
  iina
  mermaid-cli # For Mermaid diagram rendering
  spotify

  # CLI Utilities
  # File Management
  coreutils
  eza
  nnn
  stow
  tree
  unrar
  unzip
  zip

  # AI CLI Tools & Agents
  claude-code
  cursor-cli
  crush
  gemini-cli

  # Searching & Filtering
  fd
  fzf
  jc
  jq
  ripgrep
  silver-searcher
  skim

  # System & Tools
  aria2
  bash-completion
  dua
  nix-prefetch-git
  pet
  pika
  shfmt
  tldr
  watch
  wget

  # Text & Output
  bat
  fpp
  glow
  gum
  httpie
]
