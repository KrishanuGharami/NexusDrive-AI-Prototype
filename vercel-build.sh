#!/usr/bin/env bash
# ==============================================================================
# NexusDrive AI — Vercel Production Build Script
# Offline-First EV Intelligence & Edge Route Optimization Copilot
# ==============================================================================
set -e

echo "=========================================================="
echo "⚡ NexusDrive AI: Initializing Vercel Build Pipeline..."
echo "=========================================================="

# 1. Check or install Flutter SDK in Vercel Linux Container
if command -v flutter &> /dev/null; then
  echo "✔ Flutter already installed in environment."
else
  echo "📦 Flutter not detected. Installing Flutter SDK (channel: stable)..."
  FLUTTER_DIR="$HOME/flutter"
  
  if [ ! -d "$FLUTTER_DIR" ]; then
    git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_DIR"
  fi
  
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

# 2. Verify Flutter installation
echo "⚡ Checking Flutter environment:"
flutter --version
flutter config --no-analytics

# 3. Enter Flutter project directory
if [ -d "nexusdrive_ai" ]; then
  cd nexusdrive_ai
fi

echo "📦 Resolving project dependencies (flutter pub get)..."
flutter pub get

# 4. Compile optimized Flutter Web release
echo "🚀 Building Flutter Web release with CanvasKit & offline PWA..."
flutter build web --release --base-href /

# 5. Verification
if [ -f "build/web/index.html" ]; then
  echo "=========================================================="
  echo "✔ NexusDrive AI Web Build Complete!"
  echo "✔ Output: build/web (ready for Vercel Edge Network)"
  echo "=========================================================="
  ls -lh build/web
else
  echo "❌ Error: build/web/index.html not found!"
  exit 1
fi
