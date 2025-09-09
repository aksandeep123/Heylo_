import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:heylo/models/message.dart';

class ChatServiceReal {
  static Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final chatId = _getChatId(senderId, receiverId);
    final messageData = {
      'messageId': DateTime.now().millisecondsSinceEpoch.toString(),
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'isRead': false,
    };

    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('messages_$chatId') ?? '[]';
    final messages = List<Map<String, dynamic>>.from(json.decode(messagesJson));
    messages.add(messageData);
    await prefs.setString('messages_$chatId', json.encode(messages));
  }

  static Future<List<Map<String, dynamic>>> getMessages(String senderId, String receiverId) async {
    final chatId = _getChatId(senderId, receiverId);
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('messages_$chatId') ?? '[]';
    return List<Map<String, dynamic>>.from(json.decode(messagesJson));
  }

  static String _getChatId(String userId1, String userId2) {
    List<String> users = [userId1, userId2];
    users.sort();
    return users.join('_');
  }

  static Future<void> markAsRead(String senderId, String receiverId, String messageId) async {
    final chatId = _getChatId(senderId, receiverId);
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('messages_$chatId') ?? '[]';
    final messages = List<Map<String, dynamic>>.from(json.decode(messagesJson));
    
    final messageIndex = messages.indexWhere((m) => m['messageId'] == messageId);
    if (messageIndex != -1) {
      messages[messageIndex]['isRead'] = true;
      await prefs.setString('messages_$chatId', json.encode(messages));
    }
  }
}