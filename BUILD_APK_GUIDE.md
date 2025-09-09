# Build APK Guide for Heylo Chat App

## Prerequisites
- Flutter SDK installed
- Android SDK installed
- Java/Kotlin development tools

## Step 1: Prepare for Release Build

### Update App Info
Edit `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.heylo.chat"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### Update App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Heylo Chat"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

## Step 2: Build APK Commands

### Debug APK (for testing)
```bash
cd C:\Users\Lenovo\Desktop\AK\projects\chat\chat
flutter build apk --debug
```

### Release APK (for distribution)
```bash
flutter build apk --release
```

### Split APKs by architecture (smaller size)
```bash
flutter build apk --split-per-abi
```

## Step 3: Find Your APK
After building, find APK files in:
```
build/app/outputs/flutter-apk/
```

Files will be named:
- `app-debug.apk` (debug version)
- `app-release.apk` (release version)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-armeabi-v7a-release.apk` (32-bit ARM)

## Step 4: Install APK

### On Your Phone
1. Enable "Unknown Sources" in Settings > Security
2. Transfer APK to phone
3. Tap APK file to install

### Using ADB
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Step 5: Share APK
Send the APK file to +91 93708 85911 user so they can:
1. Install the app
2. Send messages to you
3. Receive your messages

## Features in APK
✅ Real WhatsApp integration
✅ Send messages to any WhatsApp number
✅ Receive message notifications
✅ Chat history storage
✅ Works offline

## Quick Build Command
```bash
flutter clean && flutter pub get && flutter build apk --release
```

The APK will be ready for sharing!