import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heylo/models/status.dart';

class StatusService {
  static const String _statusesKey = 'user_statuses';

  // Save a new status for the current user
  static Future<void> addStatus(Status status) async {
    final prefs = await SharedPreferences.getInstance();
    final statusesJson = prefs.getString(_statusesKey);
    Map<String, List<Map<String, dynamic>>> statusesMap = {};

    if (statusesJson != null) {
      final decoded = jsonDecode(statusesJson) as Map<String, dynamic>;
      statusesMap = decoded.map((key, value) {
        final list = (value as List).map((e) => Map<String, dynamic>.from(e)).toList();
        return MapEntry(key, list);
      });
    }

    final userStatuses = statusesMap[status.userName] ?? [];
    userStatuses.add(status.toMap());
    statusesMap[status.userName] = userStatuses;

    await prefs.setString(_statusesKey, jsonEncode(statusesMap));
  }

  // Get all statuses for all users
  static Future<Map<String, List<Status>>> getAllStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final statusesJson = prefs.getString(_statusesKey);
    Map<String, List<Status>> result = {};

    if (statusesJson != null) {
      final decoded = jsonDecode(statusesJson) as Map<String, dynamic>;
      decoded.forEach((userName, statusesList) {
        final list = (statusesList as List).map((e) => Status.fromMap(Map<String, dynamic>.from(e))).toList();
        result[userName] = list;
      });
    }

    return result;
  }

  // Clear all statuses for a user (optional)
  static Future<void> clearStatusesForUser(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    final statusesJson = prefs.getString(_statusesKey);
    if (statusesJson == null) return;

    final decoded = jsonDecode(statusesJson) as Map<String, dynamic>;
    decoded.remove(userName);

    await prefs.setString(_statusesKey, jsonEncode(decoded));
  }
}
