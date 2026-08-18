{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShellNoCC {
  LUA_LS_VIMRUNTIME = "${pkgs.neovim-unwrapped}/share/nvim/runtime";
  packages = with pkgs; [ lua-language-server ];
}
