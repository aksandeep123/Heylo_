import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heylo/services/whatsapp_api_service.dart';

class WebhookService {
  static void handleWebhook(Map<String, dynamic> data) {
    try {
      final entry = data['entry']?[0];
      final changes = entry?['changes']?[0];
      final value = changes?['value'];
      
      if (value?['messages'] != null) {
        for (var message in value['messages']) {
          WhatsAppApiService.handleIncomingMessage(message);
        }
      }
    } catch (e) {
      debugPrint('Error handling webhook: $e');
    }
  }
  
  static String verifyWebhook(String mode, String token, String challenge) {
    const verifyToken = 'YOUR_VERIFY_TOKEN';
    
    if (mode == 'subscribe' && token == verifyToken) {
      return challenge;
    }
    return '';
  }
}