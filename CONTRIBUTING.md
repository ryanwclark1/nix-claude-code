# Contributing to nix-claude-code

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)
- [Code of Conduct](#code-of-conduct)

## Getting Started

### Prerequisites

- Nix with flakes enabled
- Git
- GitHub account (for pull requests)
- `nix-prefetch-url` (included in Nix)
- Basic understanding of Nix language and flakes

### Understanding the Project Structure

```
nix-claude-code/
├── flake.nix              # Main flake definition and overlay
├── package.nix            # Claude Code package definition
├── scripts/
│   └── update-version.sh  # Version update automation script
├── tests/                 # Test suite
│   ├── integration-test.nix
│   ├── version-test.nix
│   └── wrapper-test.nix
├── examples/              # Usage examples
├── .github/
│   └── workflows/         # CI/CD automation
└── docs/                  # Documentation

```

## Development Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/clarkrw1/nix-claude-code.git
   cd nix-claude-code
   ```

2. **Enter the development shell:**
   ```bash
   nix develop
   ```

   This provides:
   - `nixpkgs-fmt` - Nix code formatter
   - `nix-prefetch-git` - Git repository prefetching
   - `cachix` - Binary cache management

3. **Build the package:**
   ```bash
   nix build
   ```

4. **Test the built package:**
   ```bash
   ./result/bin/claude --version
   ```

## Making Changes

### Types of Contributions

We welcome:
- Bug fixes
- Documentation improvements
- Test additions
- CI/CD improvements
- Example additions
- Package enhancements (within scope)

**Note:** This repository packages Claude Code (by Anthropic). We don't accept:
- Changes to Claude Code itself (upstream issue)
- Feature requests for Claude Code functionality (upstream issue)

### Branch Naming

Use descriptive branch names:
- `fix/description` - Bug fixes
- `feat/description` - New features
- `docs/description` - Documentation changes
- `test/description` - Test additions/improvements
- `ci/description` - CI/CD changes

### Code Style

**Nix Code:**
- Format with `nixpkgs-fmt` before committing
- Use 2 spaces for indentation
- Add comments for complex logic
- Follow existing code structure

```bash
# Format all Nix files
nixpkgs-fmt *.nix tests/*.nix
```

**Shell Scripts:**
- Use `#!/usr/bin/env bash` shebang
- Include `set -euo pipefail` for safety
- Add comments explaining non-obvious logic
- Use descriptive variable names

### Common Changes

#### Updating Claude Code Version

**Automated (preferred):**
The workflow handles this automatically every hour.

**Manual (for testing or specific needs):**
```bash
# Update to latest version
./scripts/update-version.sh

# Update to specific version
./scripts/update-version.sh --version 2.0.27

# Check for updates without applying
./scripts/update-version.sh --check
```

The script will:
1. Update version in `package.nix`
2. Fetch and calculate tarball hash
3. Verify the build succeeds
4. Update `flake.lock`

#### Modifying the Package

Edit `package.nix` for:
- Build process changes
- Wrapper script modifications
- Dependency updates
- Metadata improvements

After changes, always:
```bash
# Build locally
nix build --print-build-logs

# Run tests
nix build .#checks.x86_64-linux.wrapper-test
nix build .#checks.x86_64-linux.version-test

# Test the binary
./result/bin/claude --version
```

#### Adding Tests

Add new tests to `tests/` directory:

```nix
# tests/my-new-test.nix
{ pkgs ? import <nixpkgs> { }
, claude-code ? (import ../package.nix { inherit (pkgs) lib stdenv fetchurl nodejs_22 cacert bash; })
}:

pkgs.runCommand "my-test" {
  buildInputs = [ claude-code ];
} ''
  # Test logic here
  echo "Testing something..."
  ${claude-code}/bin/claude --help
  touch $out
''
```

Then add to `flake.nix` checks:
```nix
checks = {
  # ... existing checks
  my-test = import ./tests/my-new-test.nix {
    inherit pkgs;
    claude-code = pkgs.claude-code;
  };
};
```

#### Adding Examples

Add new examples to `examples/` directory:
1. Create example file with clear comments
2. Test the example works
3. Add documentation to `examples/README.md`
4. Include use case description

## Testing

### Running Tests

**All tests:**
```bash
# Via flake checks
nix flake check

# Individual tests
nix build .#checks.x86_64-linux.format
nix build .#checks.x86_64-linux.wrapper-test
nix build .#checks.x86_64-linux.version-test
```

**Format check:**
```bash
nixpkgs-fmt --check *.nix tests/*.nix
```

**Build verification:**
```bash
# Build for your platform
nix build

# Build for all platforms (if on Linux)
nix build .#packages.x86_64-linux.default
nix build .#packages.aarch64-linux.default
nix build .#packages.x86_64-darwin.default
nix build .#packages.aarch64-darwin.default
```

### Testing Changes Locally

Before submitting a PR, test thoroughly:

```bash
# 1. Format check
nixpkgs-fmt --check *.nix

# 2. Build
nix build

# 3. Run tests
nix flake check

# 4. Test the binary
./result/bin/claude --version
./result/bin/claude --help

# 5. Test integration
nix-shell -p result
claude --version
```

## Submitting Changes

### Pull Request Process

1. **Fork the repository** (if not a collaborator)

2. **Create a feature branch:**
   ```bash
   git checkout -b feat/my-improvement
   ```

3. **Make your changes:**
   - Follow code style guidelines
   - Add tests if applicable
   - Update documentation
   - Format Nix code

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add support for X"
   ```

   Use [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation changes
   - `test:` - Test additions/changes
   - `ci:` - CI/CD changes
   - `refactor:` - Code refactoring
   - `chore:` - Maintenance tasks

5. **Push to your fork:**
   ```bash
   git push origin feat/my-improvement
   ```

6. **Create a Pull Request:**
   - Go to GitHub and create a PR
   - Fill out the PR template
   - Link related issues
   - Describe changes clearly

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Nix code is formatted with `nixpkgs-fmt`
- [ ] Tests pass locally (`nix flake check`)
- [ ] Documentation updated if needed
- [ ] Examples updated if needed
- [ ] Commit messages follow conventional commits
- [ ] PR description is clear and complete

### Review Process

1. **Automated checks** run on all PRs:
   - Build verification on Ubuntu and macOS
   - Test suite execution
   - Format checking

2. **Manual review** by maintainers:
   - Code quality
   - Functionality
   - Documentation
   - Test coverage

3. **Feedback and iteration:**
   - Address review comments
   - Update PR as needed
   - Respond to questions

4. **Merge:**
   - PRs are typically squashed and merged
   - Automated version updates auto-merge when tests pass

## Release Process

### Automated Releases

Version updates are fully automated:

1. **Hourly check** for new Claude Code versions
2. **Automated PR** creation with version update
3. **CI testing** on Ubuntu and macOS
4. **Auto-merge** if all tests pass
5. **Cachix cache** updated automatically

### Manual Releases

For significant packaging changes (not version updates):

1. Update version/changelog if applicable
2. Create PR with changes
3. Wait for review and approval
4. Merge to main
5. Tag release (if significant):
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

## Development Tips

### Debugging Build Issues

```bash
# Verbose build output
nix build --print-build-logs

# Keep build directory on failure
nix build --keep-failed

# Enter build environment interactively
nix develop .#default
```

### Testing Different Node.js Versions

```bash
# Test with different Node.js versions
nix build --override-input nodejs_22 nixpkgs#nodejs_20
```

### Cachix Usage

```bash
# Push to cache (maintainers only)
nix build | cachix push claude-code

# Use cache for faster builds
cachix use claude-code
```

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Assume good intentions
- Respect differing viewpoints

### Reporting Issues

If you experience unacceptable behavior:
1. Contact project maintainers
2. Provide details of the incident
3. We will review and respond promptly

## Getting Help

- **Issues**: Open a GitHub issue for bugs or questions
- **Discussions**: Use GitHub Discussions for general questions
- **Documentation**: Check README.md and other docs first

## Recognition

Contributors are recognized:
- GitHub contributors page
- Release notes for significant contributions
- Maintainer status for consistent contributors

## License

By contributing, you agree that your contributions will be licensed under the MIT License (for packaging code). Claude Code itself remains proprietary software by Anthropic.

---

Thank you for contributing to nix-claude-code! 🎉
