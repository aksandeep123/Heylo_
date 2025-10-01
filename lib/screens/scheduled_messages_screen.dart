import 'package:flutter/material.dart';

class ScheduledMessagesScreen extends StatelessWidget {
  const ScheduledMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Messages'),
      ),
      body: const Center(
        child: Text(
          'Scheduled Messages feature coming soon!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
