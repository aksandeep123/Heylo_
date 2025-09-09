import 'package:flutter/material.dart';

class WhatsAppService {
  static Future<void> sendWhatsAppMessage(String phoneNumber, String message, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message sent to $phoneNumber: $message'),
        backgroundColor: Colors.green,
      ),
    );
  }

  static Future<bool> openWhatsAppChat(String phoneNumber, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp chat with $phoneNumber'),
        backgroundColor: Colors.blue,
      ),
    );
    return true;
  }

  static Future<void> shareContact(String name, String phoneNumber, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing contact: $name ($phoneNumber)'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}