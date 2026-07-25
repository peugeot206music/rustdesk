#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_CONFIG="${CUSTOM_CONFIG:-$BASE_DIR/custom.json}"

if [[ ! -f "$CUSTOM_CONFIG" ]]; then
  echo "No existe $CUSTOM_CONFIG" >&2
  exit 1
fi

mapfile -t META < <(
  python3 - "$CUSTOM_CONFIG" "$BASE_DIR" <<'PY'
import json
import pathlib
import re
import sys

cfg = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
base = pathlib.Path(sys.argv[2])

app_name = str(cfg.get("installer-name") or cfg.get("app-name") or "rustdesk").strip()
slug = re.sub(r"[^A-Za-z0-9._-]+", "-", app_name).strip("-._") or "rustdesk"
version = str(
    cfg.get("custom-client-version")
    or cfg.get("client-version")
    or cfg.get("build-version")
    or ""
).strip()
target_dir = str(
    cfg.get("download-target-dir")
    or cfg.get("publish-target-dir")
    or ""
).strip()
public_base_url = str(
    cfg.get("download-public-base-url")
    or cfg.get("publish-public-base-url")
    or ""
).strip()

matches = sorted(
    base.glob(f"{slug}-*-install.exe"),
    key=lambda path: path.stat().st_mtime,
    reverse=True,
)
installer_name = matches[0].name if matches else ""

print(slug)
print(version)
print(installer_name)
print(f"{slug.lower()}-windows-latest.json")
print(f"{slug}-latest-install.exe")
print(target_dir)
print(public_base_url)
PY
)

SLUG="${META[0]}"
VERSION="${META[1]}"
INSTALLER_NAME="${META[2]}"
MANIFEST_NAME="${META[3]}"
LATEST_ALIAS="${META[4]}"
CONFIG_TARGET_DIR="${META[5]}"
CONFIG_PUBLIC_BASE_URL="${META[6]}"
TARGET_DIR="${1:-${TARGET_DIR:-${CONFIG_TARGET_DIR:-/var/www/tindesk-downloads}}}"
PUBLIC_BASE_URL="${PUBLIC_BASE_URL:-${CONFIG_PUBLIC_BASE_URL:-https://tindesk.duckdns.org/downloads}}"

if [[ -z "$INSTALLER_NAME" ]]; then
  echo "No encontré un instalador compilado con patrón ${SLUG}-*-install.exe en $BASE_DIR" >&2
  exit 1
fi

if [[ -z "$VERSION" ]]; then
  echo "Definí custom-client-version en $CUSTOM_CONFIG antes de publicar." >&2
  exit 1
fi

install -d -m 0755 "$TARGET_DIR"
install -m 0644 "$BASE_DIR/$INSTALLER_NAME" "$TARGET_DIR/$INSTALLER_NAME"
install -m 0644 "$BASE_DIR/$INSTALLER_NAME" "$TARGET_DIR/$LATEST_ALIAS"

python3 - "$TARGET_DIR/$MANIFEST_NAME" "$PUBLIC_BASE_URL" "$INSTALLER_NAME" "$VERSION" <<'PY'
import json
import pathlib
import sys

target = pathlib.Path(sys.argv[1])
base_url = sys.argv[2].rstrip("/")
installer_name = sys.argv[3]
version = sys.argv[4]

manifest = {
    "version": version,
    "windows": {
        "url": f"{base_url}/{installer_name}"
    }
}

target.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
PY

echo "Publicado instalador: $PUBLIC_BASE_URL/$INSTALLER_NAME"
echo "Alias estable: $PUBLIC_BASE_URL/$LATEST_ALIAS"
echo "Manifest update: $PUBLIC_BASE_URL/$MANIFEST_NAME"
