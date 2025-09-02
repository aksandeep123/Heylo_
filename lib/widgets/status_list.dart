import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/models/status.dart';
import 'package:whatsapp_ui/screens/add_status_screen.dart';
import 'package:whatsapp_ui/screens/status_view_screen.dart';

class StatusList extends StatefulWidget {
  const StatusList({Key? key}) : super(key: key);

  @override
  State<StatusList> createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userStatuses.length + info.length + 1,
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
            subtitle: Text(userStatuses.isNotEmpty ? 'Tap to view status' : 'Tap to add status update'),
            onTap: () {
              if (userStatuses.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatusViewScreen(status: userStatuses.first),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddStatusScreen()),
                );
              }
            },
          );
        }
        
        if (index <= userStatuses.length) {
          final status = userStatuses[index - 1];
          return ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: tabColor, width: 3),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(status.userImage),
                radius: 27,
              ),
            ),
            title: Text(status.userName),
            subtitle: Text('${DateTime.now().difference(status.timestamp).inHours}h ago'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatusViewScreen(status: status),
                ),
              );
            },
          );
        }
        
        final contact = info[index - userStatuses.length - 1];
        return ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(contact['profilePic']!),
              radius: 27,
            ),
          ),
          title: Text(contact['name']!),
          subtitle: Text('${DateTime.now().hour - index} minutes ago'),
        );
      },
    );
  }
}