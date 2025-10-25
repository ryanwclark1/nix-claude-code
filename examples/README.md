# Claude Code Integration Examples

This directory contains examples showing different ways to integrate `nix-claude-code` into your development workflow.

## Available Examples

### 1. Home Manager (`home-manager.nix`)
Integrate Claude Code into your personal Home Manager configuration. Best for:
- Individual user installations
- Consistent environment across machines
- macOS users needing permission persistence

### 2. NixOS System Configuration (`nixos-configuration.nix`)
Install Claude Code system-wide on NixOS. Best for:
- Multi-user systems
- Server environments
- System administrators

### 3. Per-Project with direnv (`direnv/`)
Use different Claude Code versions per project. Best for:
- Project isolation
- Testing new versions before system-wide rollout
- Working with multiple projects with different requirements

### 4. Flake Template (`flake-template/`)
Starter template for new projects. Best for:
- New Nix projects
- Creating reproducible development environments
- Sharing project setups with team members

## Quick Start

Choose the example that matches your use case:

```bash
# Try without installing
nix run github:clarkrw1/nix-claude-code

# Install to your profile
nix profile install github:clarkrw1/nix-claude-code

# Use in a project with direnv
cp direnv/.envrc /path/to/project/
cd /path/to/project && direnv allow

# Start a new project with the template
cp -r flake-template/* /path/to/new/project/
cd /path/to/new/project && nix develop
```

## Comparison

| Method | Scope | Updates | Permissions | Use Case |
|--------|-------|---------|-------------|----------|
| **Home Manager** | User | Manual flake update | Per-user | Personal development |
| **NixOS** | System | System rebuild | System-wide | Production servers |
| **direnv** | Project | Per-project | Per-project | Development isolation |
| **Flake Template** | Project | Per-project | Per-project | New projects |

## Version Pinning

All examples support version pinning for reproducibility:

```nix
# Pin to specific commit
claude-code.url = "github:clarkrw1/nix-claude-code?rev=abc123";

# Pin to specific tag (when available)
claude-code.url = "github:clarkrw1/nix-claude-code?ref=refs/tags/v1.0.0";

# Use latest (default)
claude-code.url = "github:clarkrw1/nix-claude-code";
```

## Getting Help

- **Documentation**: See the [main README](../README.md)
- **Issues**: https://github.com/clarkrw1/nix-claude-code/issues
- **Contributing**: See [CONTRIBUTING.md](../CONTRIBUTING.md)
