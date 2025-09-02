import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/info.dart';
import 'package:heylo/screens/mobile_chat_screen.dart';
import 'package:heylo/screens/self_profile_screen.dart';
import 'package:heylo/screens/group_chat_screen.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/models/group.dart';
import 'package:heylo/services/whatsapp_service.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  String _getLastMessage(String contactName) {
    final messages = chatMessages[contactName];
    if (messages == null || messages.isEmpty) {
      return info.firstWhere((contact) => contact['name'] == contactName)['message'] ?? 'No messages yet';
    }
    return messages.last.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: info.length + groups.length,
        itemBuilder: (context, index) {
          // Show groups first, then contacts
          if (index < groups.length) {
            final group = groups[index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(group: group),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        group.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          group.lastMessage,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(group.profilePic),
                        radius: 30,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.group, color: Colors.green, size: 16),
                          Text(
                            group.time,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
              ],
            );
          }
          
          // Show contacts after groups
          final contactIndex = index - groups.length;
          return Column(
            children: [
              InkWell(
                onTap: () {
                  if (info[contactIndex]['isSelf'] == true) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SelfProfileScreen(),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MobileChatScreen(
                          contactName: info[contactIndex]['name'].toString(),
                          profilePic: info[contactIndex]['profilePic'].toString(),
                          phoneNumber: info[contactIndex]['phone']?.toString(),
                          contactUid: info[contactIndex]['uid']?.toString(),
                          isRegistered: (info[contactIndex]['isRegistered'] as bool?) ?? false,
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      info[contactIndex]['name'].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        _getLastMessage(info[contactIndex]['name'].toString()),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        info[contactIndex]['profilePic'].toString(),
                      ),
                      radius: 30,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            final phone = info[contactIndex]['phone']?.toString();
                            if (phone != null) {
                              WhatsAppService.openWhatsAppChat(phone, context);
                            }
                          },
                          icon: const Icon(Icons.chat, color: Colors.green, size: 20),
                        ),
                        Text(
                          info[contactIndex]['time'].toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(color: dividerColor, indent: 85),
            ],
          );
        },
      ),
    );
  }
}
