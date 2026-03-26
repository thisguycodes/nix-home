{
  enable ? true,
}:
{
  inherit enable;
  extensions = [
    "github-actions"
    "ansible"
    "deno"
    "dockerfile"
    "duckyscript"
    "gleam"
    "go-snippits"
    "golangci-lint"
    "gosum"
    "gotmpl"
    "helm"
    "jsonnet"
    "make"
    "markdown-oxide"
    "mcp-server-github"
    # "mcp-server-linear"
    "mermaid"
    "nginx"
    "nix"
    "ruby"
    "ruff"
    "sql"
    "ssh-config"
    "starlark"
    "superhtml"
    "templ"
    "terraform"
    "tmux"
    "toml"
    "typos"
    "vhs"
    "wgsl-wesl"
    "xml"
  ];
  userKeymaps = [ ];
  userSettings = {
    terminal = {
      env = {
        RIPGREP_CONFIG_PATH = "${./dotfiles/zed-rg.rc}";
      };
    };
    file_types = {
      "GitHub Actions" = [
        ".github/workflows/*.yml"
        ".github/workflows/*.yaml"
      ];
    };
    format_on_save = "on";
    vim_mode = true;
    journal = {
      path = "-";
      hour_format = "hour24";
    };
    tabs = {
      git_status = true;
    };
    relative_line_numbers = "enabled";
    soft_wrap = "editor_width";
    preferred_line_length = 120;
    wrap_guides = [
      80
      120
    ];
    lsp = {
      typos.initialization_options.diagnosticSeverity = "Hint";
      nil.initialization_options.formatting.command = [ "nixfmt" ];
      terraform-ls.initialization_options = {
        experimentalFeatures.prefillRequiredFields = true;
      };
      gopls.initialization_options = {
        templateExtensions = [ "gotmpl" ];
        usePlaceholders = true;
        staticcheck = true;
        gofumpt = true;
      };
    };
    agent = {
      default_model = {
        provider = "zed";
        model = "claude-sonnet-4-5-thinking";
      };
    };
    context_servers = {
      mcp-server-github = {
        enabled = true;
        settings = {
          github_personal_access_token = "REPLACEME";
        };
        env = { };
      };
      gopls = {
        enabled = true;
        command = "gopls";
        args = [
          "mcp"
        ];
        env = { };
      };
      "Cloudflare Docs" = {
        command = "npx";
        args = [
          "-y"
          "mcp-remote"
          "https://docs.mcp.cloudflare.com/sse"
        ];
        env = { };
      };
    };
  };
}
