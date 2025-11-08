# NixOS Configuration Example for Claude Code
#
# This example shows how to integrate nix-claude-code into your NixOS system configuration.
# This makes Claude Code available system-wide for all users.
#
# Usage:
# 1. Add this flake as an input in your NixOS flake.nix
# 2. Add the overlay to your nixpkgs configuration
# 3. Include claude-code in environment.systemPackages

{ config, pkgs, ... }:

{
  # Install claude-code system-wide
  environment.systemPackages = with pkgs; [
    claude-code
  ];

  # Optional: Configure system-wide environment variables
  environment.variables = {
    # Disable auto-updates (managed through Nix)
    DISABLE_AUTOUPDATER = "1";
  };

  # Optional: Enable cachix for faster installations
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-claude-code.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-claude-code.cachix.org-1:ZQ3wnF5SIjoMRoF/8eHRD4arEL/tRwitDehTg0//o6I="
    ];
  };

  # Optional: Create system-wide alias
  environment.shellAliases = {
    cc = "claude";
  };
}

# Complete flake.nix example:
#
# {
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#     claude-code.url = "github:ryanwclark1/nix-claude-code";
#   };
#
#   outputs = { self, nixpkgs, claude-code, ... }: {
#     nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
#       system = "x86_64-linux";
#       modules = [
#         {
#           nixpkgs.overlays = [ claude-code.overlays.default ];
#         }
#         ./configuration.nix
#         # Your other modules
#       ];
#     };
#   };
# }
