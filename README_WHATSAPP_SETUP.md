# WhatsApp Integration Setup

## Prerequisites
1. WhatsApp Business Account
2. Facebook Developer Account
3. Meta Business Account

## Setup Steps

### 1. Create WhatsApp Business API App
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app → Business → WhatsApp
3. Add WhatsApp product to your app

### 2. Get Credentials
1. **Phone Number ID**: From WhatsApp → API Setup
2. **Access Token**: Generate permanent token
3. **Verify Token**: Create your own secure token

### 3. Configure Webhook
1. Set webhook URL: `https://yourdomain.com/webhook`
2. Set verify token (same as in config)
3. Subscribe to messages field

### 4. Update Configuration
Edit `lib/config/whatsapp_config.dart`:
```dart
static const String phoneNumberId = 'YOUR_ACTUAL_PHONE_NUMBER_ID';
static const String accessToken = 'YOUR_ACTUAL_ACCESS_TOKEN';
static const String verifyToken = 'YOUR_ACTUAL_VERIFY_TOKEN';
```

### 5. Firebase Setup
1. Create Firebase project
2. Add Android/iOS apps
3. Download `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
4. Place in respective platform folders

### 6. Test Integration
1. Send test message from app
2. Verify webhook receives incoming messages
3. Check notifications work

## Important Notes
- WhatsApp Business API requires approval for production
- Test with approved phone numbers only
- Webhook must be HTTPS with valid SSL certificate