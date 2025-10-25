# NixOS VM Integration Test for Claude Code
#
# This test verifies that Claude Code can be installed and executed in a NixOS VM.
# It checks basic functionality without requiring actual API calls.
#
# Run with: nix-build tests/integration-test.nix

{ pkgs ? import <nixpkgs> { }
, claude-code ? (import ../default.nix { inherit pkgs; })
}:

pkgs.nixosTest {
  name = "claude-code-integration";

  nodes.machine = { config, pkgs, ... }: {
    environment.systemPackages = [ claude-code ];
  };

  testScript = ''
    start_all()

    # Wait for the machine to boot
    machine.wait_for_unit("multi-user.target")

    # Test 1: Verify claude binary exists
    machine.succeed("which claude")

    # Test 2: Verify version command works
    version_output = machine.succeed("claude --version")
    print(f"Claude version: {version_output}")
    assert "claude-code" in version_output.lower() or "claude" in version_output.lower(), \
      "Version output doesn't contain expected text"

    # Test 3: Verify help command works
    help_output = machine.succeed("claude --help")
    assert "usage" in help_output.lower() or "options" in help_output.lower(), \
      "Help output doesn't contain expected text"

    # Test 4: Verify Node.js is bundled (not system Node.js)
    # The wrapper should not require system Node.js
    machine.succeed("claude --version 2>&1 | grep -v 'node: command not found'")

    # Test 5: Verify NODE_PATH is set correctly in wrapper
    machine.succeed("grep 'NODE_PATH' /nix/store/*/bin/claude")

    # Test 6: Verify the wrapper script exists and is executable
    machine.succeed("test -x $(which claude)")

    # Test 7: Check that claude modules directory exists
    machine.succeed("test -d /nix/store/*-claude-code-*/lib/node_modules/@anthropic-ai/claude-code")

    print("✅ All integration tests passed!")
  '';
}
