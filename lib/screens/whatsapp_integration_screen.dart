import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/services/whatsapp_service.dart';

class WhatsAppIntegrationScreen extends StatefulWidget {
  const WhatsAppIntegrationScreen({Key? key}) : super(key: key);

  @override
  State<WhatsAppIntegrationScreen> createState() => _WhatsAppIntegrationScreenState();
}

class _WhatsAppIntegrationScreenState extends State<WhatsAppIntegrationScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool hasWhatsApp = false;

  @override
  void initState() {
    super.initState();
    checkWhatsApp();
  }

  void checkWhatsApp() async {
    final result = await WhatsAppService.hasWhatsApp();
    setState(() {
      hasWhatsApp = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heylo Integration'),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      hasWhatsApp ? Icons.check_circle : Icons.error,
                      color: hasWhatsApp ? Colors.green : Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hasWhatsApp ? 'Heylo Available' : 'Heylo Not Found',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      hasWhatsApp 
                        ? 'You can send messages to real Heylo users'
                        : 'Install Heylo to use this feature',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Send Message to Heylo User:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number (with country code)',
                hintText: '+1234567890',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.message),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: hasWhatsApp ? () {
                  if (phoneController.text.isNotEmpty && messageController.text.isNotEmpty) {
                    WhatsAppService.sendWhatsAppMessage(
                      phoneController.text,
                      messageController.text,
                      context,
                    );
                  }
                } : null,
                icon: const Icon(Icons.send),
                label: const Text('Send via Heylo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tabColor,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.chat, color: Colors.green),
              title: Text('Direct Heylo Messaging'),
              subtitle: Text('Send messages to real Heylo users'),
            ),
            const ListTile(
              leading: Icon(Icons.call, color: Colors.blue),
              title: Text('Heylo Calling'),
              subtitle: Text('Make voice and video calls via Heylo'),
            ),
            const ListTile(
              leading: Icon(Icons.share, color: Colors.orange),
              title: Text('Contact Sharing'),
              subtitle: Text('Share contacts via Heylo'),
            ),
          ],
        ),
      ),
    );
  }
}