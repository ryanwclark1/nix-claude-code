# Version Consistency Test for Claude Code
#
# This test verifies that the version in package.nix matches the actual
# version reported by the built binary.
#
# Run with: nix-build tests/version-test.nix

{ pkgs ? import <nixpkgs> { }
, claude-code ? (import ../package.nix { inherit (pkgs) lib stdenv fetchurl nodejs_22 cacert bash; })
}:

let
  # Extract version from package.nix
  packageVersion = claude-code.version;

  # Build the package
  built = claude-code;
in
pkgs.runCommand "claude-code-version-test" {
  buildInputs = [ built ];
} ''
  # Get version from binary
  echo "Testing version consistency..."
  echo "Package version: ${packageVersion}"

  # Run claude --version and capture output
  BINARY_VERSION=$(${built}/bin/claude --version 2>&1 || true)
  echo "Binary version output: $BINARY_VERSION"

  # Check if version appears in output
  if echo "$BINARY_VERSION" | grep -q "${packageVersion}"; then
    echo "✅ Version test passed: ${packageVersion} matches binary output"
    touch $out
  else
    echo "❌ Version mismatch!"
    echo "Expected version ${packageVersion} to appear in output"
    echo "Binary output was: $BINARY_VERSION"
    exit 1
  fi
''
