import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/models/status.dart';
import 'package:heylo/screens/simple_status_screen.dart';
import 'package:heylo/services/status_service.dart';
import 'package:heylo/services/real_user_service.dart';

class StatusList extends StatefulWidget {
  const StatusList({Key? key}) : super(key: key);

  @override
  State<StatusList> createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  Map<String, List<Status>> allStatuses = {};
  List<Map<String, dynamic>> contactList = [];

  @override
  void initState() {
    super.initState();
    _loadStatuses();
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      contactList = RealUserService.getRealUsers();
    });
  }

  Future<void> _loadStatuses() async {
    final statuses = await StatusService.getAllStatuses();
    setState(() {
      allStatuses = statuses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contactList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // User's own status
          final myStatuses = allStatuses['You'] ?? [];
          final latestStatus = myStatuses.isNotEmpty ? myStatuses.last : null;
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
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
            subtitle: Text(
              latestStatus != null
                  ? '${latestStatus.mediaType} • ${DateTime.now().difference(latestStatus.timestamp).inHours}h ago'
                  : 'Tap to add status update',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStatusScreen()),
              ).then((_) {
                _loadStatuses();
              });
            },
          );
        }

        final contact = contactList[index - 1];
        final statuses = allStatuses[contact['name']] ?? [];
        final latestStatus = statuses.isNotEmpty ? statuses.last : null;

        return ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: latestStatus != null ? tabColor : Colors.grey,
                width: 2,
              ),
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
          subtitle: latestStatus != null
              ? Text('${DateTime.now().difference(latestStatus.timestamp).inMinutes} minutes ago')
              : const Text('No status updates'),
          onTap: () {
            if (statuses.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatusViewScreen(statuses: statuses),
                ),
              );
            }
          },
        );
      },
    );
  }
}
