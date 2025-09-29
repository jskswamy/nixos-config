{
  config,
  pkgs,
  lib,
  user,
}: {
  enable = true;
  enableFishIntegration = true;
  settings = {
    # Global settings
    add_newline = false;
    command_timeout = 5000;
    scan_timeout = 30;

    # Define color palette for consistent theming
    palette = "catppuccin_mocha";

    palettes.catppuccin_mocha = {
      rosewater = "#f5e0dc";
      flamingo = "#f2cdcd";
      pink = "#f5c2e7";
      mauve = "#cba6f7";
      red = "#f38ba8";
      maroon = "#eba0ac";
      peach = "#fab387";
      yellow = "#f9e2af";
      green = "#a6e3a1";
      teal = "#94e2d5";
      sky = "#89dceb";
      sapphire = "#74c7ec";
      blue = "#89b4fa";
      lavender = "#b4befe";
      text = "#cdd6f4";
      subtext1 = "#bac2de";
      subtext0 = "#a6adc8";
      overlay2 = "#9399b2";
      overlay1 = "#7f849c";
      overlay0 = "#6c7086";
      surface2 = "#585b70";
      surface1 = "#45475a";
      surface0 = "#313244";
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";
    };

    character = {
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
      vicmd_symbol = "[❮](bold yellow)";
    };

    battery = {
      full_symbol = "";
      charging_symbol = "";
      discharging_symbol = "";
      disabled = false;
      display = [
        {
          threshold = 10;
          style = "bold red";
        }
      ];
    };

    kubernetes = {
      disabled = true;
      detect_env_vars = ["KUBECTL_CONTEXT" "KUBECONFIG"];
      detect_extensions = [];
      detect_files = ["k8s" ".kube"];
      detect_folders = ["k8s" ".kube" "kubernetes"];
      format = "on [⛵ ($user on )($cluster in )$context ($namespace)](dimmed green) ";
      context_aliases = {
        "dev.local.cluster.k8s" = "dev";
      };
    };

    terraform = {
      disabled = false;
      detect_extensions = ["tf" "tfplan" "tfstate"];
      detect_files = ["terraform.tfvars" ".terraform.lock.hcl"];
      detect_folders = [".terraform"];
      format = "[🏎💨 $version$workspace]($style) ";
    };

    aws = {
      symbol = " ";
      disabled = false;
      format = "on [$symbol($profile )($region )]($style) ";
      style = "bold yellow";
      region_aliases = {
        ap-south-1 = "mumbai";
        us-east-1 = "virginia";
        us-west-2 = "oregon";
      };
    };

    conda = {
      symbol = " ";
      disabled = true;
    };

    golang = {
      symbol = " ";
    };

    docker_context = {
      symbol = " ";
      detect_extensions = [];
      detect_files = ["docker-compose.yml" "docker-compose.yaml" "Dockerfile"];
      detect_folders = [];
      format = "via [🐋 $context](blue bold) ";
    };

    hg_branch = {
      symbol = " ";
      disabled = true;
    };

    java = {
      symbol = " ";
      disabled = false;
    };

    memory_usage = {
      symbol = " ";
      disabled = true;
    };

    nodejs = {
      symbol = " ";
      disabled = false;
    };

    package = {
      symbol = " ";
      disabled = false;
    };

    php = {
      symbol = " ";
      disabled = true;
    };

    python = {
      symbol = " ";
      disabled = true;
    };

    ruby = {
      symbol = " ";
    };

    rust = {
      symbol = " ";
    };

    git_status = {
      format = ''([\[$all_status$ahead_behind\]]($style) )'';
      style = "cyan";
      conflicted = "🏳";
      up_to_date = "";
      untracked = "🤷";
      ahead = "⇡\${count}";
      diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      behind = "⇣\${count}";
      stashed = "📦";
      modified = "📝";
      staged = "[++\\($count\\)](green)";
      renamed = "👅";
      deleted = "🗑";
    };

    git_branch = {
      symbol = " ";
    };

    git_state = {
      progress_divider = " of ";
      cherry_pick = "🍒 PICKING";
      disabled = true;
    };

    username = {
      disabled = true;
    };

    gcloud = {
      disabled = true;
      format = "on [$symbol$account(\\($project\\))]($style) ";
      symbol = " ";
      style = "bold yellow";
      region_aliases = {
        asia-northeast1 = "an1";
      };
    };

    nix_shell = {
      disabled = false;
      format = "via [$symbol$name](bold blue) ";
      symbol = "🐧 ";
      impure_msg = "";
      pure_msg = "🛡️";
    };

    directory = {
      truncation_length = 3;
      truncation_symbol = "…/";
      home_symbol = " ~";
      read_only_style = "197";
      read_only = "  ";
      format = "at [$path]($style)[$read_only]($read_only_style) ";
    };

    cmd_duration = {
      min_time = 2000;
      format = "took [$duration](bold yellow) ";
      style = "yellow";
    };

    jobs = {
      threshold = 1;
      symbol_threshold = 1;
      number_threshold = 2;
      format = "[$symbol$number]($style) ";
    };

    status = {
      style = "red";
      symbol = "🔴 ";
      format = ''[\[$symbol $common_meaning$signal_name$maybe_int\]]($style) '';
      map_symbol = true;
      disabled = false;
    };

    bun = {
      format = "via [🧄 $version]($style) ";
      style = "bold red";
    };

    deno = {
      format = "via [🦕 $version]($style) ";
      style = "green";
    };

    time = {
      disabled = true;
    };
  };
}
