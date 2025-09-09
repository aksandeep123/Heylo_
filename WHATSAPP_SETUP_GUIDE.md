# WhatsApp Business API Setup Guide

## Quick Setup for +91 93708 85911

### Step 1: Get WhatsApp Business API Access
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app → Business → WhatsApp
3. Add WhatsApp product to your app

### Step 2: Get Your Credentials
You need these 3 values:

1. **Phone Number ID**: 
   - Go to WhatsApp → API Setup
   - Copy the Phone Number ID (looks like: 441737405726158)

2. **Access Token**:
   - Generate a permanent access token
   - Copy the token (starts with: EAA...)

3. **Verify Token**:
   - Create your own secure string (e.g., "myapp_verify_123")

### Step 3: Update Configuration
Edit `lib/config/whatsapp_config.dart`:

```dart
static const String phoneNumberId = 'YOUR_ACTUAL_PHONE_NUMBER_ID';
static const String accessToken = 'YOUR_ACTUAL_ACCESS_TOKEN';
static const String verifyToken = 'YOUR_VERIFY_TOKEN';
```

### Step 4: Test the Integration
1. Run the app
2. Open chat with "+91 93708 85911"
3. Send a message
4. Check if it appears in the actual WhatsApp

### Step 5: Setup Webhook (Optional)
For receiving messages:
1. Deploy a webhook endpoint
2. Configure it in WhatsApp settings
3. Subscribe to 'messages' field

## Current Status
- ✅ App configured for +91 93708 85911
- ✅ Auto-reply simulation enabled
- ✅ Notifications working
- ⏳ Need real API credentials

## Test Without Real API
The app currently simulates WhatsApp integration. Messages will:
- Show "Message sent to WhatsApp!" 
- Auto-reply after 3 seconds
- Display notifications

Replace credentials in config file to enable real WhatsApp messaging.