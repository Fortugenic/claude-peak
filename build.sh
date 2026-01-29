#!/bin/bash
set -euo pipefail

APP_NAME="Claude Usage Monitor"
BUNDLE_ID="com.wecouldbe.claude-usage-monitor"
BUILD_DIR=".build/release"
APP_DIR="${BUILD_DIR}/${APP_NAME}.app"
INSTALL_DIR="$HOME/Applications"

echo "Building..."
swift build -c release

echo "Creating app bundle..."
rm -rf "${APP_DIR}"
mkdir -p "${APP_DIR}/Contents/MacOS"
mkdir -p "${APP_DIR}/Contents/Resources"

cp "${BUILD_DIR}/ClaudeUsageMonitor" "${APP_DIR}/Contents/MacOS/ClaudeUsageMonitor"
cp Resources/Info.plist "${APP_DIR}/Contents/Info.plist"

echo "Installing to ${INSTALL_DIR}..."
mkdir -p "${INSTALL_DIR}"
rm -rf "${INSTALL_DIR}/${APP_NAME}.app"
cp -R "${APP_DIR}" "${INSTALL_DIR}/${APP_NAME}.app"

echo "Done! App installed at: ${INSTALL_DIR}/${APP_NAME}.app"
echo "Run: open \"${INSTALL_DIR}/${APP_NAME}.app\""
