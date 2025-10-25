# Pull Request

## Description

<!-- Provide a clear description of your changes -->

## Type of Change

<!-- Check all that apply -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Package version update (automated)
- [ ] CI/CD improvement
- [ ] Test improvement

## Motivation and Context

<!-- Why is this change required? What problem does it solve? -->
<!-- Link to related issues if applicable: Fixes #123 -->

## Changes Made

<!-- List the specific changes made in this PR -->

-
-
-

## Testing

<!-- Describe the tests you ran to verify your changes -->

- [ ] Built the package locally: `nix build`
- [ ] Tested the binary: `./result/bin/claude --version`
- [ ] Ran format check: `nixpkgs-fmt --check *.nix`
- [ ] Ran existing tests (if applicable)
- [ ] Added new tests (if applicable)
- [ ] Tested on: <!-- e.g., x86_64-linux, aarch64-darwin -->

## Test Commands

```bash
# Commands used to test this change
nix build
./result/bin/claude --version
```

## Checklist

<!-- Check all that apply -->

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## Additional Notes

<!-- Any additional information that reviewers should know -->

---

**For Automated Version Update PRs:**

This is an automated PR created by the update workflow. The following has been automatically verified:

- Version number updated in `package.nix`
- Tarball hash calculated and updated
- `flake.lock` updated
- Build verification successful on CI

The PR will auto-merge if all checks pass.
