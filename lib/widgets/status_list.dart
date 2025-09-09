import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:heylo/colors.dart';
import 'package:heylo/models/status.dart';
import 'package:heylo/screens/simple_status_screen.dart';
import 'package:heylo/services/real_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusList extends StatefulWidget {
  const StatusList({Key? key}) : super(key: key);

  @override
  State<StatusList> createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  List<Map<String, dynamic>> contactList = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      contactList = RealUserService.getRealUsers();
    });
  }
  
  Future<String> _getMyStatusText() async {
    final prefs = await SharedPreferences.getInstance();
    final statusJson = prefs.getString('my_status');
    if (statusJson != null) {
      final statusData = jsonDecode(statusJson);
      final timestamp = DateTime.fromMillisecondsSinceEpoch(statusData['timestamp']);
      final hoursAgo = DateTime.now().difference(timestamp).inHours;
      
      if (hoursAgo < 24) {
        return statusData['text'].isNotEmpty 
            ? statusData['text'] 
            : '${statusData['mediaType']} • ${hoursAgo}h ago';
      }
    }
    return 'Tap to add status update';
  }
  
  Future<Map<String, String?>> _getMyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('profile_name') ?? 'You',
      'image': prefs.getString('profile_image'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contactList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=60',
                  ),
                  radius: 30,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: tabColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            title: const Text('My status'),
            subtitle: FutureBuilder<String>(
              future: _getMyStatusText(),
              builder: (context, snapshot) {
                return Text(snapshot.data ?? 'Tap to add status update');
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStatusScreen()),
              ).then((_) {
                setState(() {}); // Refresh after adding status
              });
            },
          );
        }
        
        // Show status only for contacts in contact list
        final contact = contactList[index - 1];
        return ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: tabColor, width: 2),
            ),
            child: CircleAvatar(
              backgroundColor: tabColor,
              child: Text(
                contact['name'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              radius: 27,
            ),
          ),
          title: Text(contact['name']),
          subtitle: Text('${DateTime.now().hour - index} minutes ago'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatusViewScreen(),
              ),
            );
          },
        );
      },
    );
  }
}