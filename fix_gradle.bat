@echo off
echo Fixing Gradle build issues...
echo.

echo Step 1: Cleaning Gradle cache...
rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul

echo Step 2: Cleaning Flutter project...
flutter clean

echo Step 3: Getting dependencies...
flutter pub get

echo Step 4: Attempting APK build...
flutter build apk --debug

echo.
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo ✅ APK built successfully!
    echo Location: build\app\outputs\flutter-apk\app-debug.apk
) else (
    echo ❌ APK build failed. Try updating Android Studio and Java JDK.
    echo Alternative: Use web version with 'flutter run -d chrome'
)
echo.
pause