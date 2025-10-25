# Flake Template for Claude Code

This template provides a starting point for projects that want to include Claude Code in their development environment using Nix flakes.

## Quick Start

1. **Copy the template to your project**:
   ```bash
   cp flake.nix /path/to/your/project/
   cd /path/to/your/project
   ```

2. **Customize for your project**:
   - Update the `description` field
   - Add your project dependencies to `buildInputs`
   - Customize the `shellHook` message

3. **Enter the development environment**:
   ```bash
   nix develop
   ```

4. **Use Claude Code**:
   ```bash
   claude --version
   ```

## Features

- **Automatic Claude Code**: Always available in your dev environment
- **Version Locked**: Uses flake.lock to ensure reproducibility
- **Easy Updates**: Run `nix flake update` to get the latest Claude Code
- **Project Isolation**: Each project can use different versions

## Updating Claude Code

To update to the latest Claude Code version:

```bash
nix flake update claude-code
```

To update all dependencies:

```bash
nix flake update
```

## Pinning Versions

To pin to a specific Claude Code version, modify the input:

```nix
claude-code.url = "github:clarkrw1/nix-claude-code?rev=abc123def456";
```

## Using with direnv

Add a `.envrc` file to automatically load the dev environment:

```bash
# .envrc
use flake
```

Then run:
```bash
direnv allow
```

## Example: Python Project

```nix
devShells.default = pkgs.mkShell {
  buildInputs = with pkgs; [
    claude-code
    python312
    python312Packages.pip
    python312Packages.virtualenv
  ];

  shellHook = ''
    echo "🐍 Python development environment with Claude Code"
    python --version
    claude --version
  '';
};
```

## Example: Node.js Project

```nix
devShells.default = pkgs.mkShell {
  buildInputs = with pkgs; [
    claude-code
    nodejs_22
    nodePackages.npm
  ];

  shellHook = ''
    echo "📦 Node.js development environment with Claude Code"
    node --version
    npm --version
    claude --version
  '';
};
```

## Example: Multi-Language Project

```nix
devShells.default = pkgs.mkShell {
  buildInputs = with pkgs; [
    claude-code
    nodejs_22
    python312
    go
    rustc
    cargo
  ];

  shellHook = ''
    echo "🛠️  Multi-language development environment"
    echo "Available: Node.js $(node --version), Python $(python --version), Go $(go version), Rust $(rustc --version)"
    echo "AI Assistant: $(claude --version)"
  '';
};
```
