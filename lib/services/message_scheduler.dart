import 'dart:async';
import 'package:heylo/models/scheduled_message.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/services/chat_service.dart';

class MessageScheduler {
  static Timer? _timer;

  static void startScheduler() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkScheduledMessages();
    });
  }

  static void stopScheduler() {
    _timer?.cancel();
  }

  static void _checkScheduledMessages() {
    final now = DateTime.now();
    final messagesToSend = scheduledMessages.where((msg) => 
      !msg.isSent && msg.scheduledTime.isBefore(now.add(const Duration(seconds: 5)))
    ).toList();

    for (final scheduledMsg in messagesToSend) {
      _sendScheduledMessage(scheduledMsg);
    }
  }

  static void _sendScheduledMessage(ScheduledMessage scheduledMsg) {
    // Create and send the message
    final message = Message(
      text: '⏰ ${scheduledMsg.text}',
      isMe: true,
      time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      contactName: scheduledMsg.contactName,
    );

    // Add to chat messages
    if (chatMessages[scheduledMsg.contactName] == null) {
      chatMessages[scheduledMsg.contactName] = [];
    }
    chatMessages[scheduledMsg.contactName]!.add(message);

    // Mark as sent and remove from scheduled messages
    scheduledMessages.removeWhere((msg) => msg.id == scheduledMsg.id);
  }
}