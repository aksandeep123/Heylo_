import 'package:flutter/material.dart';
import 'package:whatsapp_ui/widgets/my_message_card.dart';
import 'package:whatsapp_ui/widgets/sender_message_card.dart';
import 'package:whatsapp_ui/models/message.dart';

class ChatList extends StatelessWidget {
  final String contactName;
  const ChatList({Key? key, required this.contactName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messages = chatMessages[contactName] ?? [];
    
    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet. Start a conversation!',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        if (message.isMe) {
          return MyMessageCard(
            message: message.text,
            date: message.time,
          );
        }
        return SenderMessageCard(
          message: message.text,
          date: message.time,
        );
      },
    );
  }
}
