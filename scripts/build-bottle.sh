#!/usr/bin/env bash
set -euo pipefail

# Build
brew install --formula --build-bottle --verbose ./Formula/ligo.rb

# Test
brew test ./Formula/ligo.rb

# Produce bottle
brew bottle --force-core-tap --no-rebuild ./Formula/ligo.rb

# Fix bottle file name
# https://github.com/Homebrew/brew/pull/4612#commitcomment-29995084
for bottle in ./*.bottle.*; do
  mv "$bottle" "${bottle/--/-}"
done
