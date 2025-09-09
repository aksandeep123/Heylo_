import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/services/real_user_service.dart';

class CallsList extends StatefulWidget {
  const CallsList({Key? key}) : super(key: key);

  @override
  State<CallsList> createState() => _CallsListState();
}

class _CallsListState extends State<CallsList> {
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

  @override
  Widget build(BuildContext context) {
    if (contactList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.call, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No call history',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Add contacts to see call history',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        final contact = contactList[index];
        final isVideo = index % 3 == 0;
        final isIncoming = index % 2 == 0;
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: tabColor,
            child: Text(
              contact['name'][0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            radius: 25,
          ),
          title: Text(contact['name']),
          subtitle: Row(
            children: [
              Icon(
                isIncoming ? Icons.call_received : Icons.call_made,
                color: isIncoming ? Colors.red : Colors.green,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text('${DateTime.now().day - index} ${DateTime.now().hour}:${DateTime.now().minute}'),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${contact['name']}...')),
              );
            },
            icon: Icon(
              isVideo ? Icons.videocam : Icons.call,
              color: tabColor,
            ),
          ),
        );
      },
    );
  }
}