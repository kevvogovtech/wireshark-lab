#!/bin/bash
# ============================================================
# init-github.sh
# Run this script once to initialize git and push to GitHub.
# ============================================================

# ── CONFIG ──────────────────────────────────────────────────
REPO_NAME="wireshark-lab"
GITHUB_USERNAME=""          # ← fill in your GitHub username
# ────────────────────────────────────────────────────────────

if [ -z "$GITHUB_USERNAME" ]; then
  echo "❌ Error: Set your GITHUB_USERNAME at the top of this script first."
  exit 1
fi

echo "🦈 Setting up Wireshark Lab repository..."

# Initialize git
git init
git add .
git commit -m "Initial commit: Wireshark & Network Analysis lab"

# Add remote and push
git branch -M main
git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

echo ""
echo "✅ Local git initialized and committed."
echo ""
echo "Next steps:"
echo "  1. Go to https://github.com/new"
echo "  2. Create a new repository named: $REPO_NAME"
echo "  3. Leave it empty (no README, no .gitignore)"
echo "  4. Come back here and run:"
echo ""
echo "     git push -u origin main"
echo ""
echo "Your repo will be at: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
