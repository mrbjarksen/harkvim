{
  lib,
  fetchFromGitHub,
  vimUtils,
  vimPlugins,
  wrapNeovimUnstable,
  neovim-unwrapped,
}:

let
  harkvim-config = vimUtils.buildVimPlugin {
    pname = "harkvim-config";
    version = "0.1.0";
    src = ./.;
    meta = {
      homepage = "https://github.com/mrbjarksen/neo-tree-diagnostics.nvim";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ mrbjarksen ];
    };
  };

  neo-tree-diagnostics-nvim = vimUtils.buildVimPlugin {
    pname = "neo-tree-diagnostics.nvim";
    version = "0-unstable-2024-02-28";

    src = fetchFromGitHub {
      owner = "mrbjarksen";
      repo = "neo-tree-diagnostics.nvim";
      rev = "e00434c3cf8637bcaf70f65c2b9d82b0cc9bd7dc";
      hash = "sha256-HU7pFsICHK6bg03chgZ1oP6Wx2GQxk7ZJHGQnD0IMBA=";
    };

    dependencies = [ vimPlugins.neo-tree-nvim ];
    checkInputs = with vimPlugins; [ plenary-nvim nui-nvim ];

    meta = {
      homepage = "https://github.com/mrbjarksen/neo-tree-diagnostics.nvim";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ mrbjarksen ];
    };
  };

  opt = plugin: { inherit plugin; optional = true; };

  harkvim = wrapNeovimUnstable neovim-unwrapped {
    extraName = "-harkvim";

    autoconfigure = true;
    autowrapRuntimeDeps = true;

    wrapRc = false;
    wrapperArgs = [
      "--add-flags" ''--cmd "set packpath+=${harkvim-config}/after"''
      "--add-flags" ''--cmd "set rtp^=${harkvim-config}"''
      "--set-default" "NVIM_APPNAME" "harkvim"
    ];

    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
    withPerl = false;

    plugins = with vimPlugins; map opt [
      nvim-lspconfig
      nvim-treesitter
      fidget-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      neo-tree-nvim
      neo-tree-diagnostics-nvim
      nvim-autopairs
      gitsigns-nvim
      tokyonight-nvim
      catppuccin-nvim
      heirline-nvim
      indent-blankline-nvim
      dressing-nvim
      nvim-notify
      eyeliner-nvim
      vim-cool
      nvim-surround
      better-escape-nvim
      nvim-web-devicons
    ];
  };
in
  harkvim
