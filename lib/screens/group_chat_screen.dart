import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/models/group.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/screens/group_summary_screen.dart';

class GroupChatScreen extends StatefulWidget {
  final Group group;
  
  const GroupChatScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      final message = Message(
        text: messageController.text.trim(),
        isMe: true,
        time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        contactName: widget.group.name,
      );
      
      if (chatMessages[widget.group.name] == null) {
        chatMessages[widget.group.name] = [];
      }
      chatMessages[widget.group.name]!.add(message);
      
      messageController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = chatMessages[widget.group.name] ?? [];
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.group.profilePic),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.group.name, style: const TextStyle(fontSize: 18)),
                  Text(
                    '${widget.group.members.length} members',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.summarize),
                    SizedBox(width: 8),
                    Text('Group Summary'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupSummaryScreen(
                        group: widget.group,
                        messages: messages,
                      ),
                    ),
                  );
                },
              ),
              if (widget.group.admin == 'You')
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.admin_panel_settings),
                      SizedBox(width: 8),
                      Text('Manage Co-Admins'),
                    ],
                  ),
                  onTap: () async {
                    await Future.delayed(Duration.zero); // Fixes popup menu bug
                    showDialog(
                      context: context,
                      builder: (context) {
                        final nonAdmins = widget.group.members.where((m) => m != widget.group.admin && !widget.group.coAdmins.contains(m)).toList();
                        return AlertDialog(
                          title: const Text('Promote to Co-Admin'),
                          content: SizedBox(
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: nonAdmins.length,
                              itemBuilder: (context, index) {
                                final member = nonAdmins[index];
                                return ListTile(
                                  title: Text(member),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.group.coAdmins.add(member);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Promote'),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              if (widget.group.admin == 'You')
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.delete_forever, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Group', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () async {
                    await Future.delayed(Duration.zero);
                    groups.removeWhere((g) => g.id == widget.group.id);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Group deleted')),
                    );
                  },
                ),
              if (widget.group.admin != 'You' && widget.group.members.contains('You'))
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Leave Group', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () async {
                    await Future.delayed(Duration.zero);
                    setState(() {
                      widget.group.members.remove('You');
                      widget.group.coAdmins.remove('You');
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You left the group')),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet. Start the conversation!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Align(
                          alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: message.isMe ? messageColor : senderMessageColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(message.text),
                                const SizedBox(height: 4),
                                Text(
                                  message.time,
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
