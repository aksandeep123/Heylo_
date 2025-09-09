@echo off
echo Building Heylo Chat APK...
echo.

echo Step 1: Cleaning project...
flutter clean

echo Step 2: Getting dependencies...
flutter pub get

echo Step 3: Building release APK...
flutter build apk --release

echo.
echo ✅ APK build complete!
echo.
echo APK location: build\app\outputs\flutter-apk\app-release.apk
echo.
echo You can now share this APK file with +91 93708 85911
echo.
pause