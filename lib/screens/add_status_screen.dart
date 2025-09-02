import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/models/status.dart';

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({Key? key}) : super(key: key);

  @override
  State<AddStatusScreen> createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  File? selectedMedia;
  String mediaType = '';
  File? selectedMusic;
  final TextEditingController captionController = TextEditingController();

  Future<void> pickMedia() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Photo'),
              onTap: () async {
                Navigator.pop(context);
                final image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    selectedMedia = File(image.path);
                    mediaType = 'image';
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Video'),
              onTap: () async {
                Navigator.pop(context);
                final video = await picker.pickVideo(source: ImageSource.gallery);
                if (video != null) {
                  setState(() {
                    selectedMedia = File(video.path);
                    mediaType = 'video';
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickMusic() async {
    // Simplified music selection - just show a demo message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Music selection feature coming soon!')),
    );
  }

  void uploadStatus() {
    if (selectedMedia != null) {
      final status = Status(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: 'You',
        userImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=60',
        mediaPath: kIsWeb ? 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=60' : selectedMedia!.path,
        mediaType: mediaType,
        musicPath: selectedMusic?.path,
        timestamp: DateTime.now(),
      );
      
      userStatuses.insert(0, status);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status uploaded successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Status'),
        backgroundColor: appBarColor,
        actions: [
          if (selectedMedia != null)
            IconButton(
              onPressed: uploadStatus,
              icon: const Icon(Icons.send),
            ),
        ],
      ),
      body: Column(
        children: [
          if (selectedMedia != null)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.black),
                child: mediaType == 'image'
                    ? kIsWeb 
                        ? Image.network(selectedMedia!.path, fit: BoxFit.contain)
                        : Image.file(selectedMedia!, fit: BoxFit.contain)
                    : const Center(
                        child: Icon(Icons.play_circle, size: 100, color: Colors.white),
                      ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate, size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: pickMedia,
                      style: ElevatedButton.styleFrom(backgroundColor: tabColor),
                      child: const Text('Select Photo/Video'),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (selectedMusic != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.music_note, color: tabColor),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Demo Music Selected')),
                        IconButton(
                          onPressed: () => setState(() => selectedMusic = null),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: captionController,
                        decoration: const InputDecoration(
                          hintText: 'Add a caption...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: pickMusic,
                      icon: const Icon(Icons.music_note, color: tabColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}