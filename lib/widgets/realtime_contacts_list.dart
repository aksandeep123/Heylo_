import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:heylo/colors.dart';
import 'package:heylo/screens/mobile_chat_screen.dart';
import 'package:heylo/screens/simple_self_profile_screen.dart';
import 'package:heylo/services/real_user_service.dart';
import 'package:heylo/models/group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heylo/screens/group_chat_screen.dart';

class RealtimeContactsList extends StatefulWidget {
  final bool selectionMode;
  final void Function(bool)? onSelectionModeChanged;

  const RealtimeContactsList({
    Key? key,
    this.selectionMode = false,
    this.onSelectionModeChanged,
  }) : super(key: key);

  @override
  State<RealtimeContactsList> createState() => _RealtimeContactsListState();
}

class _RealtimeContactsListState extends State<RealtimeContactsList> {
  List<Map<String, dynamic>> onlineUsers = [];
  List<Group> groupChats = [];
  late bool selectionMode;
  Set<String> selectedContacts = {};

  @override
  void didUpdateWidget(covariant RealtimeContactsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectionMode != selectionMode) {
      setState(() {
        selectionMode = widget.selectionMode;
        if (!selectionMode) selectedContacts.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectionMode = widget.selectionMode;
    _loadChats();
    // Refresh every 3 seconds to show newly added contacts and groups
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _loadChats();
      }
    });
  }

  void _loadChats() {
    setState(() {
      onlineUsers = RealUserService.getRealUsers();
      groupChats = List<Group>.from(groups);
    });
  }
  
  Future<String> _getCurrentUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_name') ?? 'You';
  }
  
  Future<Map<String, String?>> _getCurrentUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('profile_name') ?? 'You',
      'image': prefs.getString('profile_image'),
    };
  }
  
  Future<String> _getCurrentUserAbout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_about') ?? 'Hey there! I am using Heylo.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Current user profile (clickable)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelfProfileScreen(),
              ),
            ).then((_) {
              // Refresh when returning from profile
              setState(() {});
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            color: chatBarMessage,
            child: Row(
              children: [
                FutureBuilder<Map<String, String?>>(
                  future: _getCurrentUserProfile(),
                  builder: (context, snapshot) {
                    final profile = snapshot.data ?? {'name': 'You', 'image': null};
                    return CircleAvatar(
                      radius: 25,
                      backgroundImage: profile['image'] != null
                          ? MemoryImage(
                              base64Decode(profile['image']!.split(',')[1]),
                            )
                          : null,
                      backgroundColor: tabColor,
                      child: profile['image'] == null
                          ? Text(
                              profile['name']![0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String>(
                        future: _getCurrentUserName(),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? 'You',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          );
                        },
                      ),
                      FutureBuilder<String>(
                        future: _getCurrentUserAbout(),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? 'Hey there! I am using Heylo.',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.edit, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
        
        // Combined users and groups list
        if (selectionMode)
          Row(
            children: [
              Expanded(
                child: Text(
                  '${selectedContacts.length} selected',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: selectedContacts.isEmpty
                    ? null
                    : () async {
                        await RealUserService.deleteContactsByName(selectedContacts.toList());
                        setState(() {
                          onlineUsers = RealUserService.getRealUsers();
                          selectedContacts.clear();
                          selectionMode = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact(s) deleted permanently')),
                        );
                      },
              ),
              IconButton(
                icon: const Icon(Icons.block, color: Colors.orange),
                onPressed: selectedContacts.isEmpty
                    ? null
                    : () {
                        setState(() {
                          // For demo: just clear selection and show snackbar
                          selectedContacts.clear();
                          selectionMode = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact(s) blocked')),
                        );
                      },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    selectionMode = false;
                    selectedContacts.clear();
                  });
                  if (widget.onSelectionModeChanged != null) {
                    widget.onSelectionModeChanged!(false);
                  }
                },
              ),
            ],
          ),
        Expanded(
          child: (onlineUsers.isEmpty && groupChats.isEmpty)
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No chats yet',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Share this APK with friends to start chatting!',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    // Show groups first
                    ...groupChats.map((group) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(group.profilePic),
                            backgroundColor: tabColor,
                            child: Text(
                              group.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(group.name),
                          subtitle: Text('Group • ${group.members.length} members'),
                          trailing: const Icon(Icons.group, color: tabColor),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupChatScreen(group: group),
                              ),
                            );
                          },
                        )),
                    // Then show users
                    ...onlineUsers.map((user) => ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: tabColor,
                                child: Text(
                                  user['name'][0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              if (user['isOnline'] == true)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: backgroundColor, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(user['name']),
                          subtitle: Text(
                            user['isOnline'] == true ? 'Online' : 'Last seen recently',
                            style: TextStyle(
                              color: user['isOnline'] == true ? Colors.green : Colors.grey,
                            ),
                          ),
                          trailing: selectionMode
                              ? Checkbox(
                                  value: selectedContacts.contains(user['name']),
                                  onChanged: (selected) {
                                    setState(() {
                                      if (selected == true) {
                                        selectedContacts.add(user['name']);
                                      } else {
                                        selectedContacts.remove(user['name']);
                                      }
                                    });
                                  },
                                )
                              : const Icon(Icons.chat, color: tabColor),
                          onTap: selectionMode
                              ? () {
                                  setState(() {
                                    if (selectedContacts.contains(user['name'])) {
                                      selectedContacts.remove(user['name']);
                                    } else {
                                      selectedContacts.add(user['name']);
                                    }
                                  });
                                }
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MobileChatScreen(
                                        contactName: user['name'],
                                        profilePic: 'https://via.placeholder.com/150',
                                        phoneNumber: user['id'],
                                        isRegistered: true,
                                      ),
                                    ),
                                  );
                                },
                          onLongPress: () {
                            setState(() {
                              selectionMode = true;
                              selectedContacts.add(user['name']);
                            });
                            if (widget.onSelectionModeChanged != null) {
                              widget.onSelectionModeChanged!(true);
                            }
                          },
                        )),
                  ],
                ),
        ),
      ],
    );
  }
}
