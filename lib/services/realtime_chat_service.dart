import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:heylo/models/message.dart';
import 'package:heylo/services/simple_notification_service.dart';
import 'package:heylo/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RealtimeChatService {
  static Timer? _syncTimer;
  static String? _currentUserId;
  static String? _currentUserName;
  static List<Map<String, dynamic>> _onlineUsers = [];
  static Map<String, List<Message>> _globalMessages = {};
  
  static Future<void> initialize() async {
    await _generateUserId();
    await _loadGlobalMessages();
    _startSyncService();
  }
  
  static Future<void> _generateUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString('user_id');
    _currentUserName = prefs.getString('user_name');
    
    if (_currentUserId == null) {
      _currentUserId = 'user_${Random().nextInt(999999).toString().padLeft(6, '0')}';
      _currentUserName = 'User ${Random().nextInt(9999)}';
      await prefs.setString('user_id', _currentUserId!);
      await prefs.setString('user_name', _currentUserName!);
    }
  }
  
  static Future<void> _loadGlobalMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('global_messages');
    if (messagesJson != null) {
      final Map<String, dynamic> data = jsonDecode(messagesJson);
      _globalMessages.clear();
      data.forEach((key, value) {
        _globalMessages[key] = (value as List).map((msg) => Message.fromMap(msg)).toList();
      });
    }
  }
  
  static Future<void> _saveGlobalMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, List<Map<String, dynamic>>> data = {};
    _globalMessages.forEach((key, value) {
      data[key] = value.map((msg) => msg.toMap()).toList();
    });
    await prefs.setString('global_messages', jsonEncode(data));
  }
  
  static void _startSyncService() {
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _syncWithOtherUsers();
    });
  }
  
  static void _syncWithOtherUsers() {
    // Load real users who have installed the app
    _loadRealUsers();
    
    // Only simulate messages from real users occasionally
    if (Random().nextInt(10) == 0 && _onlineUsers.isNotEmpty) {
      _simulateIncomingMessage();
    }
  }
  
  static void _loadRealUsers() {
    // In a real implementation, this would sync with a server
    // For now, we'll only show users when they actually send messages
    // This creates a more realistic experience where users appear when active
  }
  
  static void _simulateIncomingMessage() {
    // Only simulate if there are actual users to simulate from
    if (_onlineUsers.isEmpty) return;
    
    final sender = _onlineUsers[Random().nextInt(_onlineUsers.length)];
    final messages = [
      'Hey! How are you?',
      'Thanks for the message!',
      'Good to hear from you!',
      'What\'s up?',
      'Hope you\'re doing well!',
    ];
    
    final messageText = messages[Random().nextInt(messages.length)];
    final senderName = sender['name'];
    
    final message = Message(
      text: messageText,
      isMe: false,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: senderName,
    );
    
    if (_globalMessages[senderName] == null) {
      _globalMessages[senderName] = [];
    }
    _globalMessages[senderName]!.add(message);
    
    if (chatMessages[senderName] == null) {
      chatMessages[senderName] = [];
    }
    chatMessages[senderName]!.add(message);
    
    _saveGlobalMessages();
    StorageService.saveMessages();
    
    SimpleNotificationService.showNotification(
      title: senderName,
      body: messageText,
    );
  }
  
  static Future<bool> sendMessage(String recipientName, String messageText) async {
    final message = Message(
      text: messageText,
      isMe: true,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: recipientName,
    );
    
    // Add to global messages
    if (_globalMessages[recipientName] == null) {
      _globalMessages[recipientName] = [];
    }
    _globalMessages[recipientName]!.add(message);
    
    // Add to local messages
    if (chatMessages[recipientName] == null) {
      chatMessages[recipientName] = [];
    }
    chatMessages[recipientName]!.add(message);
    
    await _saveGlobalMessages();
    await StorageService.saveMessages();
    
    // Simulate reply after 2-5 seconds
    Timer(Duration(seconds: 2 + Random().nextInt(3)), () {
      _simulateReply(recipientName);
    });
    
    return true;
  }
  
  static void _simulateReply(String recipientName) {
    final replies = [
      'Thanks for your message!',
      'Hey! Good to hear from you!',
      'How are you doing?',
      'That\'s interesting!',
      'I agree with you!',
      'Tell me more about that.',
      'Sounds great!',
      'I\'m doing well, thanks for asking!',
    ];
    
    final reply = replies[Random().nextInt(replies.length)];
    
    final message = Message(
      text: reply,
      isMe: false,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: recipientName,
    );
    
    if (_globalMessages[recipientName] == null) {
      _globalMessages[recipientName] = [];
    }
    _globalMessages[recipientName]!.add(message);
    
    if (chatMessages[recipientName] == null) {
      chatMessages[recipientName] = [];
    }
    chatMessages[recipientName]!.add(message);
    
    _saveGlobalMessages();
    StorageService.saveMessages();
    
    SimpleNotificationService.showNotification(
      title: recipientName,
      body: reply,
    );
  }
  
  static List<Map<String, dynamic>> getOnlineUsers() {
    return _onlineUsers;
  }
  
  static String? getCurrentUserId() => _currentUserId;
  static String? getCurrentUserName() => _currentUserName;
  
  static void dispose() {
    _syncTimer?.cancel();
  }
}