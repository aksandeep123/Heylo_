import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:html' as html;

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({Key? key}) : super(key: key);

  @override
  State<AddStatusScreen> createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  final TextEditingController textController = TextEditingController();
  String? selectedMedia;
  String mediaType = 'text'; // 'text', 'image', 'video'

  Future<void> _pickMedia(String type) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = type == 'image' ? 'image/*' : 'video/*';
    uploadInput.click();
    
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        
        reader.onLoadEnd.listen((e) {
          setState(() {
            selectedMedia = reader.result as String;
            mediaType = type;
          });
        });
        
        reader.readAsDataUrl(file);
      }
    });
  }

  Future<void> _addStatus() async {
    if (textController.text.trim().isEmpty && selectedMedia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add text or select media'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final statusData = {
      'text': textController.text.trim(),
      'media': selectedMedia,
      'mediaType': mediaType,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    await prefs.setString('my_status', jsonEncode(statusData));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Add Status'),
        actions: [
          IconButton(
            onPressed: _addStatus,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (selectedMedia != null) ...[

              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: mediaType == 'image'
                    ? Image.memory(
                        base64Decode(selectedMedia!.split(',')[1]),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.black,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle, size: 50, color: Colors.white),
                              Text('Video Selected', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMedia = null;
                    mediaType = 'text';
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Remove Media'),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickMedia('image'),
                    icon: const Icon(Icons.image),
                    label: const Text('Image'),
                    style: ElevatedButton.styleFrom(backgroundColor: tabColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickMedia('video'),
                    icon: const Icon(Icons.videocam),
                    label: const Text('Video'),
                    style: ElevatedButton.styleFrom(backgroundColor: tabColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Add Status',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusViewScreen extends StatelessWidget {
  const StatusViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Status'),
      ),
      body: const Center(
        child: Text(
          'Status viewer coming soon!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class SelfProfileScreen extends StatelessWidget {
  const SelfProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text(
          'Profile settings coming soon!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}