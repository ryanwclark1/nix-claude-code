# Home Manager Configuration Example for Claude Code
#
# This example shows how to integrate nix-claude-code into your Home Manager configuration.
# Home Manager is a system for managing user environments using Nix.
#
# Usage:
# 1. Add this flake as an input in your flake.nix
# 2. Add the overlay to your nixpkgs configuration
# 3. Include claude-code in your home.packages
#
# For more information: https://github.com/nix-community/home-manager

{ config, pkgs, ... }:

{
  # Add claude-code to your packages
  home.packages = with pkgs; [
    claude-code
  ];

  # Optional: Configure shell aliases for convenience
  programs.bash.shellAliases = {
    cc = "claude";
  };

  programs.zsh.shellAliases = {
    cc = "claude";
  };

  # Optional: Create a stable symlink for macOS permission persistence
  # This prevents macOS from asking for permissions after each Nix update
  home.file.".local/bin/claude" = {
    source = "${pkgs.claude-code}/bin/claude";
    # Make sure .local/bin is in your PATH
  };

  # Ensure .local/bin is in your PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Optional: Set environment variables
  home.sessionVariables = {
    # Disable auto-updates (managed through Nix)
    DISABLE_AUTOUPDATER = "1";
  };
}

# Complete flake.nix example:
#
# {
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
#     home-manager = {
#       url = "github:nix-community/home-manager";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#     claude-code.url = "github:clarkrw1/nix-claude-code";
#   };
#
#   outputs = { nixpkgs, home-manager, claude-code, ... }: {
#     homeConfigurations."username" = home-manager.lib.homeManagerConfiguration {
#       pkgs = import nixpkgs {
#         system = "x86_64-linux";  # or "aarch64-darwin", etc.
#         overlays = [ claude-code.overlays.default ];
#       };
#       modules = [
#         ./home.nix
#         # Your other modules
#       ];
#     };
#   };
# }
