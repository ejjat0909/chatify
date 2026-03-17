#!/bin/bash

# Extract version from pubspec.yaml (e.g., "1.0.7+7" -> "1.0.7")
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: *//' | sed 's/+.*//')

echo "Building APK for version $VERSION..."

# Build the release APK
flutter build apk --release

# Check if build was successful
if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

# APK output directory
APK_DIR="build/app/outputs/flutter-apk"
SOURCE_APK="$APK_DIR/app-release.apk"

# Copy APK with generic name
cp "$SOURCE_APK" "$APK_DIR/chatify.apk"
echo "✓ Created $APK_DIR/chatify.apk"

# Copy APK with version name
cp "$SOURCE_APK" "$APK_DIR/chatify_${VERSION}.apk"
echo "✓ Created $APK_DIR/chatify_${VERSION}.apk"

echo ""
echo "Release build completed successfully!"
echo "APK files are located in '$APK_DIR'"
