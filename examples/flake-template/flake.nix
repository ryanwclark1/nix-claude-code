# Flake Template for Projects Using Claude Code
#
# This is a starter template for new projects that want to include Claude Code
# in their development environment.
#
# Usage:
# 1. Copy this file to your project root
# 2. Modify the description and add your project dependencies
# 3. Run: nix develop

{
  description = "My project with Claude Code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    claude-code.url = "github:ryanwclark1/nix-claude-code";
  };

  outputs = { self, nixpkgs, flake-utils, claude-code }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ claude-code.overlays.default ];
        };
      in
      {
        # Development shell with Claude Code and your project dependencies
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Claude Code
            claude-code

            # Add your project dependencies here
            # For example:
            # nodejs_22
            # python3
            # go
            # rust
          ];

          shellHook = ''
            echo "🚀 Development environment loaded"
            echo "Claude Code version: $(claude --version)"
            echo ""
            echo "Available commands:"
            echo "  claude       - AI coding assistant"
            # Add your project-specific commands here
          '';
        };

        # Optional: Make Claude Code available as a package
        packages.default = pkgs.claude-code;
      }
    );
}
