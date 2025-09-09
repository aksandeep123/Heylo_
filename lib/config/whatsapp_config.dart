class WhatsAppConfig {
  // Set to true to use direct WhatsApp opening (no API needed)
  static const bool useMockService = true;
  
  // WhatsApp Business API credentials (you need to get these from Meta)
  static const String phoneNumberId = '441737405726158';
  static const String accessToken = 'EAAYour_Access_Token_Here';
  static const String verifyToken = 'your_verify_token_123';
  static const String webhookUrl = 'https://your-domain.com/webhook';
  
  // Target phone number
  static const String targetPhoneNumber = '919370885911';
  
  // API endpoints
  static String get messagesUrl => 'https://graph.facebook.com/v17.0/$phoneNumberId/messages';
  static const String graphApiUrl = 'https://graph.facebook.com/v17.0';
}