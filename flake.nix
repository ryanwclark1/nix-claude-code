{
  description = "Nix package for Claude Code - AI coding assistant in your terminal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlay = final: prev: {
        claude-code = final.callPackage ./package.nix { };
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ overlay ];
        };
      in
      {
        packages = {
          default = pkgs.claude-code;
          claude-code = pkgs.claude-code;
        };

        apps = {
          default = {
            type = "app";
            program = "${pkgs.claude-code}/bin/claude";
            meta = {
              description = "Claude Code - AI coding assistant in your terminal";
              homepage = "https://github.com/clarkrw1/nix-claude-code";
            };
          };
          claude-code = {
            type = "app";
            program = "${pkgs.claude-code}/bin/claude";
            meta = {
              description = "Claude Code - AI coding assistant in your terminal";
              homepage = "https://github.com/clarkrw1/nix-claude-code";
            };
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt
            nix-prefetch-git
            cachix
          ];
        };

        # Checks for CI/CD and local verification
        checks = {
          # Format check
          format = pkgs.runCommand "check-nix-format" { } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out
          '';

          # Build verification
          build = pkgs.claude-code;

          # Wrapper test
          wrapper-test = import ./tests/wrapper-test.nix {
            inherit pkgs;
            claude-code = pkgs.claude-code;
          };

          # Version test
          version-test = import ./tests/version-test.nix {
            inherit pkgs;
            claude-code = pkgs.claude-code;
          };
        };
      }) // {
        overlays.default = overlay;
      };
}
