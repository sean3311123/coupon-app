name: Build APK

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.9'
          channel: 'stable'
          cache: true

      - name: Flutter version
        run: flutter --version

      - name: Get dependencies
        run: flutter pub get

      - name: Analyze (non-blocking)
        run: flutter analyze --no-fatal-infos || true

      - name: Build APK
        run: flutter build apk --release --target-platform android-arm64

      - name: Rename APK
        run: |
          mv build/app/outputs/flutter-apk/app-release.apk \
             build/app/outputs/flutter-apk/coupon-app-v1.0.0.apk

      - name: Upload APK Artifact
        uses: actions/upload-artifact@v4
        with:
          name: coupon-app-apk
          path: build/app/outputs/flutter-apk/coupon-app-v1.0.0.apk
          retention-days: 30

      - name: Create Release (optional)
        if: startsWith(github.ref, 'refs/tags/')
        uses: softprops/action-gh-release@v1
        with:
          files: build/app/outputs/flutter-apk/coupon-app-v1.0.0.apk
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
