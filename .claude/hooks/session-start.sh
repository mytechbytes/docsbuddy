#!/bin/bash
# SessionStart hook — Claude Code on the web.
# Installs the Flutter SDK (version pinned to match .github/workflows/build.yml)
# and fetches pub dependencies so `flutter analyze` / `flutter test` work.
# The container caches state after the hook completes, so the SDK download
# happens once per environment; later sessions take the fast path.
set -euo pipefail

# Local sessions manage their own Flutter install.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_VERSION="3.44.2"
FLUTTER_HOME="/opt/flutter"

installed_version() {
  grep -o '"frameworkVersion": "[^"]*"' "$FLUTTER_HOME/bin/cache/flutter.version.json" 2>/dev/null \
    | cut -d'"' -f4 || true
}

if [ ! -x "$FLUTTER_HOME/bin/flutter" ] || [ "$(installed_version)" != "$FLUTTER_VERSION" ]; then
  echo "Installing Flutter $FLUTTER_VERSION..."
  rm -rf "$FLUTTER_HOME"
  curl -sSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    | tar -xJ -C /opt
  git config --global --add safe.directory "$FLUTTER_HOME"
  "$FLUTTER_HOME/bin/flutter" config --no-analytics >/dev/null 2>&1 || true
fi

# Expose the SDK (and the pre-installed Chromium for flutter-web) to the session.
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"\$PATH:$FLUTTER_HOME/bin\"" >> "$CLAUDE_ENV_FILE"
  if [ -x /opt/pw-browsers/chromium ]; then
    echo 'export CHROME_EXECUTABLE=/opt/pw-browsers/chromium' >> "$CLAUDE_ENV_FILE"
  fi
fi

cd "$CLAUDE_PROJECT_DIR"
"$FLUTTER_HOME/bin/flutter" pub get
echo "Flutter $FLUTTER_VERSION ready."
