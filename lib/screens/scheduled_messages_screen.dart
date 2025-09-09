import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/models/scheduled_message.dart';
import 'package:heylo/services/storage_service.dart';

class ScheduledMessagesScreen extends StatefulWidget {
  const ScheduledMessagesScreen({Key? key}) : super(key: key);

  @override
  State<ScheduledMessagesScreen> createState() => _ScheduledMessagesScreenState();
}

class _ScheduledMessagesScreenState extends State<ScheduledMessagesScreen> {
  void deleteScheduledMessage(int index) async {
    setState(() {
      scheduledMessages.removeAt(index);
    });
    await StorageService.saveScheduledMessages();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scheduled message deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Messages'),
        backgroundColor: appBarColor,
      ),
      body: scheduledMessages.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule_send, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No scheduled messages',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: scheduledMessages.length,
              itemBuilder: (context, index) {
                final message = scheduledMessages[index];
                final isOverdue = message.scheduledTime.isBefore(DateTime.now());
                
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isOverdue ? Colors.red : tabColor,
                      child: Icon(
                        isOverdue ? Icons.error : Icons.schedule_send,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(message.contactName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Scheduled: ${message.scheduledTime.day}/${message.scheduledTime.month} at ${TimeOfDay.fromDateTime(message.scheduledTime).format(context)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isOverdue)
                          const Icon(Icons.warning, color: Colors.red, size: 20),
                        IconButton(
                          onPressed: () => deleteScheduledMessage(index),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}