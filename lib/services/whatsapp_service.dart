import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class WhatsAppService {
  // Send message to WhatsApp user
  static Future<void> sendWhatsAppMessage(String phoneNumber, String message, BuildContext context) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final encodedMessage = Uri.encodeComponent(message);
    
    // WhatsApp deep link
    final whatsappUrl = 'https://wa.me/$cleanPhone?text=$encodedMessage';
    final whatsappUri = Uri.parse(whatsappUrl);
    
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        _showError(context, 'WhatsApp not installed');
      }
    } catch (e) {
      _showError(context, 'Failed to open WhatsApp: $e');
    }
  }

  // Check if user has WhatsApp
  static Future<bool> hasWhatsApp() async {
    final whatsappUri = Uri.parse('https://wa.me/');
    return await canLaunchUrl(whatsappUri);
  }

  // Open WhatsApp chat with user
  static Future<void> openWhatsAppChat(String phoneNumber, BuildContext context) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final whatsappUrl = 'https://wa.me/$cleanPhone';
    final whatsappUri = Uri.parse(whatsappUrl);
    
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        _showError(context, 'WhatsApp not installed');
      }
    } catch (e) {
      _showError(context, 'Failed to open WhatsApp: $e');
    }
  }

  // Share contact via WhatsApp
  static Future<void> shareContact(String name, String phoneNumber, BuildContext context) async {
    final message = 'Contact: $name\nPhone: $phoneNumber';
    await sendWhatsAppMessage('', message, context);
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}