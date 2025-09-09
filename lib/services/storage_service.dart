import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:heylo/info.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/models/group.dart';
import 'package:heylo/models/scheduled_message.dart';

class StorageService {
  static const String _contactsKey = 'contacts';
  static const String _messagesKey = 'chat_messages';
  static const String _groupsKey = 'groups';
  static const String _scheduledKey = 'scheduled_messages';

  static Future<void> saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = json.encode(info);
    await prefs.setString(_contactsKey, contactsJson);
  }

  static Future<void> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString(_contactsKey);
    if (contactsJson != null) {
      final List<dynamic> contactsList = json.decode(contactsJson);
      info.clear();
      info.addAll(contactsList.cast<Map<String, dynamic>>());
    }
  }

  static Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesMap = <String, List<Map<String, dynamic>>>{};
    chatMessages.forEach((key, value) {
      messagesMap[key] = value.map((msg) => msg.toMap()).toList();
    });
    final messagesJson = json.encode(messagesMap);
    await prefs.setString(_messagesKey, messagesJson);
  }

  static Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString(_messagesKey);
    if (messagesJson != null) {
      final Map<String, dynamic> messagesMap = json.decode(messagesJson);
      chatMessages.clear();
      messagesMap.forEach((key, value) {
        chatMessages[key] = (value as List).map((msg) => Message.fromMap(msg)).toList();
      });
    }
  }

  static Future<void> saveGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = json.encode(groups.map((g) => {
      'id': g.id,
      'name': g.name,
      'profilePic': g.profilePic,
      'members': g.members,
      'lastMessage': g.lastMessage,
      'time': g.time,
    }).toList());
    await prefs.setString(_groupsKey, groupsJson);
  }

  static Future<void> loadGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString(_groupsKey);
    if (groupsJson != null) {
      final List<dynamic> groupsList = json.decode(groupsJson);
      groups.clear();
      groups.addAll(groupsList.map((g) => Group(
        id: g['id'],
        name: g['name'],
        profilePic: g['profilePic'],
        members: List<String>.from(g['members']),
        lastMessage: g['lastMessage'],
        time: g['time'],
      )));
    }
  }

  static Future<void> saveScheduledMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduledJson = json.encode(scheduledMessages.map((s) => {
      'id': s.id,
      'text': s.text,
      'contactName': s.contactName,
      'scheduledTime': s.scheduledTime.millisecondsSinceEpoch,
      'isSent': s.isSent,
    }).toList());
    await prefs.setString(_scheduledKey, scheduledJson);
  }

  static Future<void> loadScheduledMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduledJson = prefs.getString(_scheduledKey);
    if (scheduledJson != null) {
      final List<dynamic> scheduledList = json.decode(scheduledJson);
      scheduledMessages.clear();
      scheduledMessages.addAll(scheduledList.map((s) => ScheduledMessage(
        id: s['id'],
        text: s['text'],
        contactName: s['contactName'],
        scheduledTime: DateTime.fromMillisecondsSinceEpoch(s['scheduledTime']),
        isSent: s['isSent'],
      )));
    }
  }

  static Future<void> saveAll() async {
    await Future.wait([
      saveContacts(),
      saveMessages(),
      saveGroups(),
      saveScheduledMessages(),
    ]);
  }

  static Future<void> loadAll() async {
    await Future.wait([
      loadContacts(),
      loadMessages(),
      loadGroups(),
      loadScheduledMessages(),
    ]);
  }
}