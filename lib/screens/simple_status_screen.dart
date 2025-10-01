import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/models/status.dart';
import 'package:heylo/services/status_service.dart';
import 'package:heylo/services/real_user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({Key? key}) : super(key: key);

  @override
  State<AddStatusScreen> createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  final TextEditingController textController = TextEditingController();
  File? selectedMedia;
  String mediaType = 'text'; // 'text', 'image', 'video'

  Future<void> _pickMedia(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        selectedMedia = File(pickedFile.path);
        mediaType = type;
      });
    }
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

    final currentUser = 'You'; // Replace with actual current user name or id
    final status = Status(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: currentUser,
      userImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=60',
      mediaPath: selectedMedia != null ? selectedMedia!.path : '',
      mediaType: mediaType,
      timestamp: DateTime.now(),
      viewedBy: [],
    );

    await StatusService.addStatus(status);

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
                    ? Image.file(
                        selectedMedia!,
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

class StatusViewScreen extends StatefulWidget {
  final List<Status> statuses;

  const StatusViewScreen({Key? key, required this.statuses}) : super(key: key);

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStatus() {
    if (currentIndex < widget.statuses.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStatus() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.statuses.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text('Status'),
        ),
        body: const Center(
          child: Text(
            'No statuses to view',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    final currentStatus = widget.statuses[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            _previousStatus();
          } else {
            _nextStatus();
          }
        },
        child: Stack(
          children: [
            // Status content
            PageView.builder(
              controller: _pageController,
              itemCount: widget.statuses.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final status = widget.statuses[index];
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: status.mediaType == 'image'
                        ? Image.file(
                            File(status.mediaPath),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text(
                                'Failed to load image',
                                style: TextStyle(color: Colors.white),
                              );
                            },
                          )
                        : const Text(
                            'Video playback not implemented',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                );
              },
            ),

            // Progress indicators
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(
                  widget.statuses.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color: index <= currentIndex ? Colors.white : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Header
            Positioned(
              top: 70,
              left: 10,
              right: 10,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(currentStatus.userImage),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentStatus.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${DateTime.now().difference(currentStatus.timestamp).inMinutes} minutes ago',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Text overlay if present
            if (currentStatus.mediaPath.isNotEmpty && currentStatus.mediaType == 'text')
              Positioned(
                bottom: 100,
                left: 20,
                right: 20,
                child: Text(
                  currentStatus.mediaPath,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
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