import 'dart:async';
import 'package:heylo/models/message.dart';

class ChatService {
  static Timer? _timer;
  
  static void startAutoReply(String contactName) {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      _sendAutoReply(contactName);
    });
  }
  
  static void _sendAutoReply(String contactName) {
    final replies = [
      'Hey! How are you?',
      'Thanks for your message!',
      'I\'ll get back to you soon.',
      'That sounds great!',
      'Sure, let me know.',
    ];
    
    final reply = (replies..shuffle()).first;
    
    final message = Message(
      text: reply,
      isMe: false,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: contactName,
    );
    
    if (chatMessages[contactName] == null) {
      chatMessages[contactName] = [];
    }
    chatMessages[contactName]!.add(message);
  }
  
  static void dispose() {
    _timer?.cancel();
  }
}