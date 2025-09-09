import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';

class WhatsAppIntegrationScreen extends StatefulWidget {
  const WhatsAppIntegrationScreen({Key? key}) : super(key: key);

  @override
  State<WhatsAppIntegrationScreen> createState() => _WhatsAppIntegrationScreenState();
}

class _WhatsAppIntegrationScreenState extends State<WhatsAppIntegrationScreen> {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Heylo Integration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: chatBarMessage,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isConnected ? Icons.check_circle : Icons.error,
                          color: isConnected ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isConnected ? 'Connected to Heylo' : 'Not Connected',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isConnected 
                        ? 'Your Heylo integration is active and working.'
                        : 'Connect to Heylo to sync your messages.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.message, color: tabColor),
              title: Text('Send messages directly'),
              subtitle: Text('Send messages through Heylo integration'),
            ),
            const ListTile(
              leading: Icon(Icons.sync, color: tabColor),
              title: Text('Auto-sync conversations'),
              subtitle: Text('Keep your chats synchronized'),
            ),
            const ListTile(
              leading: Icon(Icons.notifications, color: tabColor),
              title: Text('Real-time notifications'),
              subtitle: Text('Get notified of new messages'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isConnected = !isConnected;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isConnected ? 'Connected to Heylo!' : 'Disconnected from Heylo',
                      ),
                      backgroundColor: isConnected ? Colors.green : Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConnected ? Colors.red : tabColor,
                  padding: const EdgeInsets.all(16),
                ),
                child: Text(
                  isConnected ? 'Disconnect' : 'Connect to Heylo',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}