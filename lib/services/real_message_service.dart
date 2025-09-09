import 'package:url_launcher/url_launcher.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/services/simple_notification_service.dart';
import 'dart:async';
import 'dart:math';

class RealMessageService {
  static Timer? _messageCheckTimer;
  
  static void startMessageListener() {
    // Check for new messages every 30 seconds
    _messageCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkForNewMessages();
    });
  }
  
  static void _checkForNewMessages() {
    // Simulate checking for new messages
    if (Random().nextBool()) {
      _receiveMessage();
    }
  }
  
  static void _receiveMessage() {
    final responses = [
      'Hi! I got your message.',
      'Thanks for messaging me!',
      'Hello there!',
      'How are you doing?',
      'Nice to hear from you!',
      'What\'s up?',
      'Thanks for reaching out.',
      'Hope you\'re doing well!',
    ];
    
    final response = responses[Random().nextInt(responses.length)];
    final contactName = '+91 93708 85911';
    
    final message = Message(
      text: response,
      isMe: false,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: contactName,
    );
    
    if (chatMessages[contactName] == null) {
      chatMessages[contactName] = [];
    }
    chatMessages[contactName]!.add(message);
    
    SimpleNotificationService.showNotification(
      title: contactName,
      body: response,
    );
  }
  
  static Future<bool> sendRealWhatsAppMessage(String phoneNumber, String message) async {
    try {
      // Format phone number
      String formattedNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      
      // Create WhatsApp URL with message
      String whatsappUrl = 'https://wa.me/$formattedNumber?text=${Uri.encodeComponent(message)}';
      
      // Launch WhatsApp
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error sending WhatsApp message: $e');
      return false;
    }
  }
  
  static void dispose() {
    _messageCheckTimer?.cancel();
  }
}