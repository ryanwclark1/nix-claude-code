# Tests for Claude Code Nix Package

This directory contains tests to verify the Claude Code Nix package works correctly.

## Available Tests

### 1. Integration Test (`integration-test.nix`)
Full NixOS VM test that verifies Claude Code can be installed and executed.

**What it tests:**
- Binary installation
- Version command execution
- Help command functionality
- Node.js bundling
- Wrapper script configuration
- Module directory structure

**Run:**
```bash
nix-build tests/integration-test.nix
```

### 2. Version Test (`version-test.nix`)
Verifies that the version in `package.nix` matches the version reported by the binary.

**What it tests:**
- Version consistency between package definition and binary output
- Binary execution

**Run:**
```bash
nix-build tests/version-test.nix
```

### 3. Wrapper Test (`wrapper-test.nix`)
Tests the wrapper script for correct configuration and environment variables.

**What it tests:**
- Wrapper executability
- NODE_PATH configuration
- DISABLE_AUTOUPDATER flag
- CLAUDE_EXECUTABLE_PATH setting
- Node.js 22 bundling
- npm wrapper for update interception
- File structure integrity

**Run:**
```bash
nix-build tests/wrapper-test.nix
```

## Running All Tests

Run all tests at once:

```bash
# Run each test
nix-build tests/integration-test.nix
nix-build tests/version-test.nix
nix-build tests/wrapper-test.nix

# Or use a simple script
for test in tests/*.nix; do
  echo "Running $test..."
  nix-build "$test" && echo "✅ $test passed" || echo "❌ $test failed"
done
```

## CI Integration

These tests are automatically run in CI on:
- Pull requests
- Pushes to main branch
- Manual workflow triggers

See `.github/workflows/test-pr.yml` for the CI configuration.

## Adding New Tests

When adding new tests:

1. Create a new `.nix` file in this directory
2. Follow the existing pattern with clear test descriptions
3. Add documentation to this README
4. Consider adding the test to CI workflows

## Test Guidelines

- **Fast**: Tests should complete in under 2 minutes
- **Isolated**: Each test should be independent
- **Clear**: Test output should clearly indicate pass/fail
- **Documented**: Each test should explain what it verifies

## Debugging Test Failures

If a test fails:

1. **Check the output**: Test scripts print detailed error messages
2. **Run locally**: Use `nix-build tests/<test-name>.nix`
3. **Inspect the build**: Look at the generated `/nix/store/` output
4. **Check logs**: Use `--print-build-logs` for detailed output

Example:
```bash
nix-build tests/wrapper-test.nix --print-build-logs
```

## Manual Testing

For manual testing beyond automated tests:

```bash
# Build and test locally
nix build
./result/bin/claude --version

# Test in a clean environment
nix-shell -p (import ./default.nix {})
claude --version

# Test with different Node.js versions (should work regardless)
nix-shell -p nodejs_18
claude --version  # Should still work with bundled Node.js 22
```
