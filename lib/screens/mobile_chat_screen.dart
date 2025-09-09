import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/widgets/chat_list.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/services/chat_service.dart';
import 'package:heylo/services/chat_service_real.dart';
import 'package:heylo/services/simple_call_service.dart';
import 'package:heylo/services/auth_service.dart';
import 'package:heylo/services/simple_whatsapp_service.dart';
// Removed external service imports
import 'package:heylo/services/real_user_service.dart';
import 'dart:async';
import 'package:heylo/screens/schedule_message_screen.dart';
import 'package:heylo/services/storage_service.dart';

class MobileChatScreen extends StatefulWidget {
  final String contactName;
  final String profilePic;
  final String? phoneNumber;
  final String? contactUid;
  final bool isRegistered;
  
  const MobileChatScreen({
    Key? key,
    required this.contactName,
    required this.profilePic,
    this.phoneNumber,
    this.contactUid,
    this.isRegistered = false,
  }) : super(key: key);

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {

  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      final messageText = messageController.text.trim();
      
      // Send via real user service
      final success = await RealUserService.sendMessage(
        widget.contactName,
        messageText,
      );
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message sent to ${widget.contactName}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      // Also store locally
      final message = Message(
        text: messageText,
        isMe: true,
        time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        contactName: widget.contactName,
      );
      
      if (chatMessages[widget.contactName] == null) {
        chatMessages[widget.contactName] = [];
      }
      chatMessages[widget.contactName]!.add(message);
      await StorageService.saveMessages();
      
      messageController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profilePic),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    widget.isRegistered ? 'online' : 'not on Heylo',
                    style: TextStyle(
                      fontSize: 12, 
                      color: widget.isRegistered ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              if (widget.phoneNumber != null) {
                CallService.makeVideoCall(widget.phoneNumber!, context);
              }
            },
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {
              if (widget.phoneNumber != null) {
                CallService.makeVoiceCall(widget.phoneNumber!, context);
              }
            },
            icon: const Icon(Icons.call),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.schedule_send),
                    SizedBox(width: 8),
                    Text('Schedule Message'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleMessageScreen(
                        contactName: widget.contactName,
                      ),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.open_in_new),
                    SizedBox(width: 8),
                    Text('Open in WhatsApp'),
                  ],
                ),
                onTap: () {
                  if (widget.phoneNumber != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening chat with ${widget.phoneNumber}')),
                    );
                  }
                },
              ),
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share Contact'),
                  ],
                ),
                onTap: () {
                  if (widget.phoneNumber != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sharing contact: ${widget.contactName}')),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(contactName: widget.contactName),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: mobileChatBoxColor,
                      hintText: 'Type a message!',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: sendMessage,
                  backgroundColor: tabColor,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
