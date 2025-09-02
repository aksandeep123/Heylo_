import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/info.dart';

class SelfProfileScreen extends StatefulWidget {
  const SelfProfileScreen({Key? key}) : super(key: key);

  @override
  State<SelfProfileScreen> createState() => _SelfProfileScreenState();
}

class _SelfProfileScreenState extends State<SelfProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final selfContact = info.firstWhere((contact) => contact['isSelf'] == true);
    nameController.text = selfContact['name'].toString();
    statusController.text = selfContact['message'].toString();
  }

  Future<void> changeProfilePicture() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  updateProfilePic(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  updateProfilePic(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Default Images'),
              onTap: () {
                Navigator.pop(context);
                showDefaultImages();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDefaultImages() {
    final defaultImages = [
      'https://images.unsplash.com/photo-1494790108755-2616b612b786?auto=format&fit=crop&w=400&q=60',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=60',
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=60',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=60',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=400&q=60',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Profile Picture'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: defaultImages.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                updateProfilePic(defaultImages[index]);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(defaultImages[index]),
                radius: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateProfilePic(String imagePath) {
    setState(() {
      final selfIndex = info.indexWhere((contact) => contact['isSelf'] == true);
      info[selfIndex]['profilePic'] = imagePath;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture updated!')),
    );
  }

  void saveProfile() {
    final selfIndex = info.indexWhere((contact) => contact['isSelf'] == true);
    setState(() {
      info[selfIndex]['name'] = nameController.text;
      info[selfIndex]['message'] = statusController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final selfContact = info.firstWhere((contact) => contact['isSelf'] == true);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: saveProfile,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(selfContact['profilePic'].toString()),
                    radius: 80,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: tabColor,
                      onPressed: changeProfilePicture,
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(
                labelText: 'About',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.info),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(selfContact['phone'].toString()),
            ),
          ],
        ),
      ),
    );
  }
}