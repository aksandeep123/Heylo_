import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/info.dart';
import 'package:heylo/services/auth_service.dart';
import 'package:heylo/services/storage_service.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void addContact() async {
    if (nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty) {
      final phoneNumber = phoneController.text.trim();
      
      // Check if user exists in Firebase
      final existingUser = await AuthService.getUserByPhone(phoneNumber);
      
      final newContact = <String, dynamic>{
        'name': nameController.text.trim(),
        'message': existingUser != null ? 'Available on Heylo' : 'Invite to Heylo',
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
        'profilePic': existingUser?.profilePic ?? 'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=60',
        'phone': phoneNumber,
        'uid': existingUser?.uid,
        'isRegistered': existingUser != null,
      };
      
      // Register user if they provided their own number
      if (existingUser == null) {
        try {
          await AuthService.signInWithPhone(phoneNumber, nameController.text.trim());
          newContact['isRegistered'] = true;
          newContact['message'] = 'Available on Heylo';
        } catch (e) {
          // Keep as unregistered contact
        }
      }
      
      info.add(newContact);
      await StorageService.saveContacts();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(existingUser != null ? 'Contact added - Available on Heylo!' : 'Contact added - Will be invited to Heylo')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: addContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: tabColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Add Contact'),
            ),
          ],
        ),
      ),
    );
  }
}