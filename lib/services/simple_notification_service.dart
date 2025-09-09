import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class SimpleNotificationService {
  static Future<void> initialize() async {
    if (kIsWeb) {
      await _requestWebPermission();
    }
  }
  
  static Future<void> _requestWebPermission() async {
    if (html.Notification.supported) {
      await html.Notification.requestPermission();
    }
  }
  
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb && html.Notification.supported) {
      if (html.Notification.permission == 'granted') {
        html.Notification(title, body: body, icon: '/favicon.png');
      }
    }
  }
}