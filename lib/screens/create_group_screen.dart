import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/models/group.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  List<String> selectedMembers = [];

  void toggleMember(String memberName) {
    setState(() {
      if (selectedMembers.contains(memberName)) {
        selectedMembers.remove(memberName);
      } else {
        selectedMembers.add(memberName);
      }
    });
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && selectedMembers.isNotEmpty) {
      final group = Group(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: groupNameController.text.trim(),
        profilePic: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=400&q=60',
        members: selectedMembers,
        lastMessage: 'Group created',
        time: 'now',
      );
      
      groups.add(group);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group created successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter group name and select members')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = info.where((contact) => contact['isSelf'] != true).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group'),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: createGroup,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: groupNameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
            ),
          ),
          if (selectedMembers.isNotEmpty)
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedMembers.length,
                itemBuilder: (context, index) {
                  final member = selectedMembers[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                info.firstWhere((c) => c['name'] == member)['profilePic'].toString(),
                              ),
                              radius: 25,
                            ),
                            Positioned(
                              top: -5,
                              right: -5,
                              child: GestureDetector(
                                onTap: () => toggleMember(member),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(member, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final isSelected = selectedMembers.contains(contact['name']);
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(contact['profilePic'].toString()),
                    radius: 25,
                  ),
                  title: Text(contact['name'].toString()),
                  subtitle: Text(contact['phone']?.toString() ?? ''),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (_) => toggleMember(contact['name'].toString()),
                    activeColor: tabColor,
                  ),
                  onTap: () => toggleMember(contact['name'].toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}