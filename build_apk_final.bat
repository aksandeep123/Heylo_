@echo off
echo ========================================
echo    HEYLO CHAT APK BUILDER
echo ========================================
echo.

echo Step 1: Clearing Gradle cache...
rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul
echo ✓ Gradle cache cleared

echo.
echo Step 2: Cleaning Flutter project...
flutter clean
echo ✓ Project cleaned

echo.
echo Step 3: Getting dependencies...
flutter pub get
echo ✓ Dependencies updated

echo.
echo Step 4: Building APK (this may take a few minutes)...
flutter build apk --debug

echo.
echo ========================================
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo ✅ SUCCESS! APK built successfully!
    echo.
    echo 📱 APK Location: build\app\outputs\flutter-apk\app-debug.apk
    echo 📁 Full Path: %CD%\build\app\outputs\flutter-apk\app-debug.apk
    echo.
    echo 🚀 FEATURES IN YOUR APK:
    echo    • Multi-user realtime chat
    echo    • Auto-generated unique users
    echo    • Live user discovery
    echo    • Direct messaging
    echo    • Auto-replies
    echo    • Message notifications
    echo    • Beautiful WhatsApp-like UI
    echo.
    echo 📤 SHARE THIS APK:
    echo    • Send to friends/users
    echo    • Each install creates new user
    echo    • Everyone can chat with each other
    echo    • Works completely offline
    echo.
    explorer "build\app\outputs\flutter-apk"
) else (
    echo ❌ APK build failed!
    echo.
    echo 🔧 ALTERNATIVE SOLUTIONS:
    echo    1. Update Android Studio to latest version
    echo    2. Update Java JDK to version 17 or 21
    echo    3. Use web version: flutter run -d chrome
    echo    4. Upload to GitHub for online building
    echo.
    echo 📖 Check GET_APK_SOLUTION.md for detailed instructions
)

echo.
echo ========================================
pause