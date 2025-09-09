import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/services/simple_notification_service.dart';
import 'package:heylo/services/storage_service.dart';

class RealUserService {
  static Timer? _syncTimer;
  static String? _currentUserId;
  static String? _currentUserName;
  static List<Map<String, dynamic>> _realUsers = [];
  
  static Future<void> initialize() async {
    await _generateUserId();
    await _loadRealUsers();
    await _registerUser();
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
  
  static Future<void> _registerUser() async {
    // Add current user to the real users list
    final currentUser = {
      'id': _currentUserId!,
      'name': _currentUserName!,
      'isOnline': true,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
      'isCurrentUser': true,
    };
    
    // Check if user already exists
    final existingIndex = _realUsers.indexWhere((user) => user['id'] == _currentUserId);
    if (existingIndex != -1) {
      _realUsers[existingIndex] = currentUser;
    } else {
      _realUsers.add(currentUser);
    }
    
    await _saveRealUsers();
  }
  
  static Future<void> _loadRealUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('real_users');
    if (usersJson != null) {
      final List<dynamic> usersList = jsonDecode(usersJson);
      _realUsers = usersList.cast<Map<String, dynamic>>();
    }
  }
  
  static Future<void> _saveRealUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('real_users', jsonEncode(_realUsers));
  }
  
  static void _startSyncService() {
    _syncTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateUserActivity();
    });
  }
  
  static void _updateUserActivity() {
    // Update current user's last seen
    final currentUserIndex = _realUsers.indexWhere((user) => user['id'] == _currentUserId);
    if (currentUserIndex != -1) {
      _realUsers[currentUserIndex]['lastSeen'] = DateTime.now().millisecondsSinceEpoch;
      _saveRealUsers();
    }
  }
  
  static Future<void> addContact(String contactName, String phoneNumber) async {
    // Add new contact to real users list
    if (!_realUsers.any((user) => user['name'] == contactName)) {
      _realUsers.add({
        'id': 'user_${Random().nextInt(999999).toString().padLeft(6, '0')}',
        'name': contactName,
        'phone': phoneNumber,
        'isOnline': Random().nextBool(),
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
        'isCurrentUser': false,
      });
      await _saveRealUsers();
    }
  }
  
  static Future<bool> sendMessage(String recipientName, String messageText) async {
    final message = Message(
      text: messageText,
      isMe: true,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: recipientName,
    );
    
    if (chatMessages[recipientName] == null) {
      chatMessages[recipientName] = [];
    }
    chatMessages[recipientName]!.add(message);
    
    await StorageService.saveMessages();
    
    // Add recipient to real users if they don't exist (when someone messages them)
    if (!_realUsers.any((user) => user['name'] == recipientName)) {
      _realUsers.add({
        'id': 'user_${Random().nextInt(999999).toString().padLeft(6, '0')}',
        'name': recipientName,
        'isOnline': true,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
        'isCurrentUser': false,
      });
      await _saveRealUsers();
    }
    
    // Simulate reply after 3-8 seconds
    Timer(Duration(seconds: 3 + Random().nextInt(5)), () {
      _simulateReply(recipientName);
    });
    
    return true;
  }
  
  static void _simulateReply(String recipientName) {
    final replies = [
      'Thanks for your message!',
      'Hey! Good to hear from you!',
      'How are you doing?',
      'That is interesting!',
      'I agree with you!',
      'Tell me more about that.',
      'Sounds great!',
      'I am doing well, thanks for asking!',
    ];
    
    final reply = replies[Random().nextInt(replies.length)];
    
    final message = Message(
      text: reply,
      isMe: false,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: recipientName,
    );
    
    if (chatMessages[recipientName] == null) {
      chatMessages[recipientName] = [];
    }
    chatMessages[recipientName]!.add(message);
    
    StorageService.saveMessages();
    
    SimpleNotificationService.showNotification(
      title: recipientName,
      body: reply,
    );
  }
  
  static List<Map<String, dynamic>> getRealUsers() {
    // Return only other users (not current user)
    return _realUsers.where((user) => user['id'] != _currentUserId).toList();
  }
  
  static String? getCurrentUserId() => _currentUserId;
  static String? getCurrentUserName() => _currentUserName;
  
  static void dispose() {
    _syncTimer?.cancel();
  }
}