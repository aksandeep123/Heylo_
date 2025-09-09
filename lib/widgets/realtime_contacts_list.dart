import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:heylo/colors.dart';
import 'package:heylo/screens/mobile_chat_screen.dart';
import 'package:heylo/screens/simple_self_profile_screen.dart';
import 'package:heylo/services/real_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RealtimeContactsList extends StatefulWidget {
  const RealtimeContactsList({Key? key}) : super(key: key);

  @override
  State<RealtimeContactsList> createState() => _RealtimeContactsListState();
}

class _RealtimeContactsListState extends State<RealtimeContactsList> {
  List<Map<String, dynamic>> onlineUsers = [];

  @override
  void initState() {
    super.initState();
    _loadOnlineUsers();
    // Refresh every 3 seconds to show newly added contacts
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _loadOnlineUsers();
      }
    });
  }

  void _loadOnlineUsers() {
    setState(() {
      onlineUsers = RealUserService.getRealUsers();
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
        
        // Online users list
        Expanded(
          child: onlineUsers.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No other users yet',
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
              : ListView.builder(
                  itemCount: onlineUsers.length,
                  itemBuilder: (context, index) {
                    final user = onlineUsers[index];
                    return ListTile(
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
                      trailing: const Icon(Icons.chat, color: tabColor),
                      onTap: () {
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
                    );
                  },
                ),
        ),
      ],
    );
  }
}