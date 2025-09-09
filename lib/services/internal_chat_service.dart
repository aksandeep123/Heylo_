import 'dart:async';
import 'dart:math';
import 'package:heylo/models/message.dart';
import 'package:heylo/services/simple_notification_service.dart';
import 'package:heylo/services/storage_service.dart';

class InternalChatService {
  static Timer? _messageTimer;
  static final List<String> _activeUsers = ['+91 93708 85911', 'John Doe', 'Sarah Smith'];
  
  static void startChatService() {
    _messageTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _simulateIncomingMessage();
    });
  }
  
  static void _simulateIncomingMessage() {
    if (Random().nextBool()) {
      final user = _activeUsers[Random().nextInt(_activeUsers.length)];
      _receiveMessage(user);
    }
  }
  
  static void _receiveMessage(String contactName) {
    final responses = [
      'Hello! How are you?',
      'Thanks for your message!',
      'What\'s up?',
      'Nice to hear from you!',
      'How\'s your day going?',
      'Hope you\'re doing well!',
      'Let\'s catch up soon!',
      'Thanks for reaching out!',
    ];
    
    final response = responses[Random().nextInt(responses.length)];
    
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
    
    StorageService.saveMessages();
    
    SimpleNotificationService.showNotification(
      title: contactName,
      body: response,
    );
  }
  
  static Future<bool> sendMessage(String contactName, String messageText) async {
    final message = Message(
      text: messageText,
      isMe: true,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: contactName,
    );
    
    if (chatMessages[contactName] == null) {
      chatMessages[contactName] = [];
    }
    chatMessages[contactName]!.add(message);
    
    await StorageService.saveMessages();
    
    // Simulate reply after 3-8 seconds
    Timer(Duration(seconds: 3 + Random().nextInt(5)), () {
      _receiveMessage(contactName);
    });
    
    return true;
  }
  
  static void dispose() {
    _messageTimer?.cancel();
  }
}