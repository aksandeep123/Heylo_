import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:heylo/models/user.dart' as model;

class AuthService {
  static const String _usersKey = 'registered_users';

  static Future<void> signInWithPhone(String phoneNumber, String name) async {
    try {
      final user = model.User(
        uid: phoneNumber.replaceAll('+', '').replaceAll(' ', ''),
        name: name,
        phoneNumber: phoneNumber,
        profilePic: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=60',
        isOnline: true,
        lastSeen: DateTime.now(),
      );

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final users = List<Map<String, dynamic>>.from(json.decode(usersJson));
      
      // Check if user already exists
      final existingIndex = users.indexWhere((u) => u['phoneNumber'] == phoneNumber);
      if (existingIndex != -1) {
        users[existingIndex] = user.toMap();
      } else {
        users.add(user.toMap());
      }
      
      await prefs.setString(_usersKey, json.encode(users));
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<model.User?> getCurrentUser() async {
    try {
      return model.User(
        uid: 'current_user',
        name: 'You',
        phoneNumber: '+1234567890',
        profilePic: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=60',
        isOnline: true,
        lastSeen: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  static Future<model.User?> getUserByPhone(String phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final users = List<Map<String, dynamic>>.from(json.decode(usersJson));
      
      final userMap = users.firstWhere(
        (u) => u['phoneNumber'] == phoneNumber,
        orElse: () => <String, dynamic>{},
      );
      
      if (userMap.isNotEmpty) {
        return model.User.fromMap(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}