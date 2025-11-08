# Per-Project Claude Code with direnv

This example shows how to use Claude Code on a per-project basis using [direnv](https://direnv.net/).

## Why Use direnv?

- **Project Isolation**: Each project can use a specific version of Claude Code
- **Automatic Loading**: Claude Code is available only when you're in the project directory
- **Version Pinning**: Lock to specific versions for reproducible development environments
- **No Global Installation**: Doesn't interfere with system-wide or user packages

## Setup

1. **Install direnv**:
   ```bash
   # NixOS
   nix-env -iA nixpkgs.direnv

   # Home Manager
   programs.direnv.enable = true;
   ```

2. **Hook direnv into your shell**:
   ```bash
   # Bash
   echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

   # Zsh
   echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc

   # Fish
   echo 'direnv hook fish | source' >> ~/.config/fish/config.fish
   ```

3. **Copy `.envrc` to your project**:
   ```bash
   cp .envrc /path/to/your/project/
   cd /path/to/your/project
   direnv allow
   ```

4. **Claude Code is now available**:
   ```bash
   claude --version
   ```

## Version Pinning

To pin to a specific version, modify `.envrc`:

```bash
# Pin to a specific commit
use flake "github:ryanwclark1/nix-claude-code?rev=da133785bb80087238253173a3a3a601dafcfee5"

# Pin to a specific flake revision
use flake "github:ryanwclark1/nix-claude-code?ref=refs/tags/v2.0.27"
```

## Using with Flakes

You can also add claude-code to your project's `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    claude-code.url = "github:ryanwclark1/nix-claude-code";
  };

  outputs = { nixpkgs, claude-code, ... }: {
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      packages = [
        claude-code.packages.x86_64-linux.default
      ];
    };
  };
}
```

Then use:
```bash
# .envrc
use flake
```
