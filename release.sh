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

# Create apk directory if it doesn't exist
mkdir -p apk

# Source APK location
SOURCE_APK="build/app/outputs/flutter-apk/app-release.apk"

# Copy APK with generic name
cp "$SOURCE_APK" "apk/chatify.apk"
echo "✓ Created apk/chatify.apk"

# Copy APK with version name
cp "$SOURCE_APK" "apk/chatify_${VERSION}.apk"
echo "✓ Created apk/chatify_${VERSION}.apk"

echo ""
echo "Release build completed successfully!"
echo "APK files are located in the 'apk' directory"
