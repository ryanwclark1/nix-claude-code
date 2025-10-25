# Wrapper Script Test for Claude Code
#
# This test verifies that the wrapper script is correctly configured
# with all necessary environment variables and paths.
#
# Run with: nix-build tests/wrapper-test.nix

{ pkgs ? import <nixpkgs> { }
, claude-code ? (import ../package.nix { inherit (pkgs) lib stdenv fetchurl nodejs_22 cacert bash; })
}:

pkgs.runCommand "claude-code-wrapper-test" {
  buildInputs = [ claude-code pkgs.gnugrep ];
} ''
  echo "Testing wrapper script configuration..."

  WRAPPER="${claude-code}/bin/claude"

  # Test 1: Wrapper exists and is executable
  if [ ! -x "$WRAPPER" ]; then
    echo "❌ Wrapper is not executable"
    exit 1
  fi
  echo "✅ Wrapper is executable"

  # Test 2: Wrapper contains NODE_PATH export
  if ! grep -q "NODE_PATH" "$WRAPPER"; then
    echo "❌ Wrapper doesn't set NODE_PATH"
    exit 1
  fi
  echo "✅ Wrapper sets NODE_PATH"

  # Test 3: Wrapper contains reference to output path
  if ! grep -q "${claude-code}" "$WRAPPER"; then
    echo "❌ Wrapper doesn't reference output path"
    exit 1
  fi
  echo "✅ Wrapper references correct output path"

  # Test 4: Wrapper sets DISABLE_AUTOUPDATER
  if ! grep -q "DISABLE_AUTOUPDATER" "$WRAPPER"; then
    echo "❌ Wrapper doesn't disable auto-updates"
    exit 1
  fi
  echo "✅ Wrapper disables auto-updates"

  # Test 5: Wrapper uses bundled Node.js
  if ! grep -q "${pkgs.nodejs_22}" "$WRAPPER"; then
    echo "❌ Wrapper doesn't use bundled Node.js"
    exit 1
  fi
  echo "✅ Wrapper uses bundled Node.js 22"

  # Test 6: Wrapper creates npm wrapper for update interception
  if ! grep -q "_CLAUDE_NPM_WRAPPER" "$WRAPPER"; then
    echo "❌ Wrapper doesn't create npm wrapper"
    exit 1
  fi
  echo "✅ Wrapper creates npm wrapper for update interception"

  # Test 7: Wrapper sets CLAUDE_EXECUTABLE_PATH for permission persistence
  if ! grep -q "CLAUDE_EXECUTABLE_PATH" "$WRAPPER"; then
    echo "❌ Wrapper doesn't set CLAUDE_EXECUTABLE_PATH"
    exit 1
  fi
  echo "✅ Wrapper sets CLAUDE_EXECUTABLE_PATH"

  # Test 8: Wrapper contains shebang
  if ! head -n1 "$WRAPPER" | grep -q "#!"; then
    echo "❌ Wrapper missing shebang"
    exit 1
  fi
  echo "✅ Wrapper has correct shebang"

  # Test 9: Node modules directory exists
  NODE_MODULES="${claude-code}/lib/node_modules/@anthropic-ai/claude-code"
  if [ ! -d "$NODE_MODULES" ]; then
    echo "❌ Node modules directory not found"
    exit 1
  fi
  echo "✅ Node modules directory exists"

  # Test 10: cli.js exists
  if [ ! -f "$NODE_MODULES/cli.js" ]; then
    echo "❌ cli.js not found"
    exit 1
  fi
  echo "✅ cli.js exists"

  echo ""
  echo "✅ All wrapper tests passed!"
  touch $out
''
