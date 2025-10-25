# Version Management

This document explains how versioning works in `nix-claude-code` and how to manage different versions for your use case.

## Automatic Updates

This repository automatically updates to the latest Claude Code version:
- **Frequency**: Hourly checks via GitHub Actions
- **Process**: Automated PR creation, testing, and auto-merge
- **Latency**: Typically 30-60 minutes after npm publication

## Using the Latest Version

By default, using the flake gives you the latest version:

```bash
# Always use latest
nix run github:clarkrw1/nix-claude-code

# Install latest to profile
nix profile install github:clarkrw1/nix-claude-code
```

## Pinning to Specific Versions

### Method 1: Pin to Specific Commit

The most reliable way to pin to a specific version:

```nix
{
  inputs = {
    claude-code.url = "github:clarkrw1/nix-claude-code?rev=da133785bb80087238253173a3a3a601dafcfee5";
  };
}
```

**Finding commit hashes:**
```bash
# View recent commits and their Claude Code versions
git log --oneline | head -20

# Each commit message shows the version, e.g.:
# da13378 chore: update claude-code to version 2.0.27
```

### Method 2: Use Flake Lock

Let Nix manage the version via `flake.lock`:

```nix
{
  inputs = {
    claude-code.url = "github:clarkrw1/nix-claude-code";
  };
}
```

Then control updates explicitly:

```bash
# Update to latest
nix flake update claude-code

# Update all inputs
nix flake update

# See what would update without changing anything
nix flake update --dry-run
```

### Method 3: Local Path

Use a local checkout for development or testing:

```nix
{
  inputs = {
    claude-code.url = "path:/home/user/code/nix-claude-code";
  };
}
```

## Version Compatibility Matrix

| Claude Code Version | Minimum Nix Version | Node.js Version | Status |
|---------------------|---------------------|-----------------|--------|
| 2.0.x | 2.4.0+ | 22.x LTS | Current |
| 1.x.x | 2.4.0+ | 22.x LTS | Legacy |

## Checking Your Version

```bash
# Check installed version
claude --version

# Check flake version without installing
nix eval github:clarkrw1/nix-claude-code#packages.x86_64-linux.claude-code.version

# Check what version a specific commit provides
nix eval github:clarkrw1/nix-claude-code?rev=abc123#packages.x86_64-linux.claude-code.version
```

## Version Update Strategies

### Strategy 1: Always Latest (Recommended for Personal Use)

```nix
inputs.claude-code.url = "github:clarkrw1/nix-claude-code";
```

**Pros:**
- Always have latest features and fixes
- No manual intervention needed

**Cons:**
- Potential for unexpected changes
- Less reproducible across team members

**Best for:** Personal development, experimentation

### Strategy 2: Locked with Periodic Updates (Recommended for Teams)

```nix
inputs.claude-code.url = "github:clarkrw1/nix-claude-code";
```

Then update explicitly:
```bash
# Update once a week/month
nix flake update claude-code
```

**Pros:**
- Balance of stability and newness
- Reproducible across team
- Control over when updates happen

**Cons:**
- Requires manual updates
- May miss critical fixes

**Best for:** Team projects, production use

### Strategy 3: Pinned to Specific Version (Maximum Stability)

```nix
inputs.claude-code.url = "github:clarkrw1/nix-claude-code?rev=da133785bb80087238253173a3a3a601dafcfee5";
```

**Pros:**
- Maximum reproducibility
- No surprise changes
- Ideal for CI/CD

**Cons:**
- Manual version bumps required
- May miss important updates

**Best for:** Critical projects, CI/CD, auditing

## Rolling Back to Previous Versions

If a new version causes issues, roll back easily:

### Method 1: Find and Use Previous Commit

```bash
# Find the commit with the version you want
git log --oneline --all | grep "version 2.0.26"
# Output: 88db4ca chore: update claude-code to version 2.0.26

# Use that specific version
nix run github:clarkrw1/nix-claude-code?rev=88db4ca
```

### Method 2: Use Flake Lock History

```bash
# If using flake.lock, revert to previous lock state
git log flake.lock

# Checkout previous version
git checkout <commit-hash> flake.lock

# Rebuild with previous version
nix develop
```

### Method 3: Profile Rollback

```bash
# If installed via nix profile, list generations
nix profile history

# Rollback to previous generation
nix profile rollback
```

## Overriding Node.js Version

While we bundle Node.js 22 LTS, you can override if needed:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    claude-code.url = "github:clarkrw1/nix-claude-code";
  };

  outputs = { nixpkgs, claude-code, ... }: {
    packages.x86_64-linux.default =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
      claude-code.packages.x86_64-linux.default.override {
        nodejs_22 = pkgs.nodejs_20;  # Use Node.js 20 instead
      };
  };
}
```

**Warning:** Using different Node.js versions is not officially supported and may break functionality.

## Version Notification

Subscribe to updates:

1. **GitHub Releases**: Watch the repository for releases
2. **GitHub Discussions**: New versions are announced in Discussions
3. **RSS Feed**: Subscribe to releases RSS feed:
   ```
   https://github.com/clarkrw1/nix-claude-code/releases.atom
   ```

## Troubleshooting Version Issues

### Problem: "Version mismatch" error

```bash
# Clear Nix cache
nix-collect-garbage

# Update flake inputs
nix flake update

# Rebuild
nix build github:clarkrw1/nix-claude-code
```

### Problem: Old version persists after update

```bash
# Check what version flake.lock points to
nix flake metadata

# Force update
nix flake update --recreate-lock-file

# For nix profile installations, reinstall
nix profile remove claude-code
nix profile install github:clarkrw1/nix-claude-code
```

### Problem: Want specific version not in repository

If you need a Claude Code version that's not in the repository:

1. Fork the repository
2. Manually update `package.nix` version and hash
3. Build from your fork:
   ```bash
   nix build github:yourusername/nix-claude-code?rev=yourcommit
   ```

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on manual version updates.

## See Also

- [README.md](README.md) - General usage and installation
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute and manual updates
- [examples/](examples/) - Integration examples with different version pinning strategies
