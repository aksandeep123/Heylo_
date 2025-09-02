import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/info.dart';

class CallsList extends StatelessWidget {
  const CallsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: info.length,
      itemBuilder: (context, index) {
        final contact = info[index];
        final isVideo = index % 3 == 0;
        final isIncoming = index % 2 == 0;
        
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(contact['profilePic']!),
            radius: 25,
          ),
          title: Text(contact['name']!),
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