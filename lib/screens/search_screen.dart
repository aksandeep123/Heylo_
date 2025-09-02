import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/screens/mobile_chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = info;
  }

  void filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredContacts = info;
      } else {
        filteredContacts = info
            .where((contact) =>
                contact['name'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: filterContacts,
        ),
      ),
      body: ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = filteredContacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(contact['profilePic'].toString()),
              radius: 25,
            ),
            title: Text(contact['name'].toString()),
            subtitle: Text(contact['message'].toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MobileChatScreen(
                    contactName: contact['name'].toString(),
                    profilePic: contact['profilePic'].toString(),
                    phoneNumber: contact['phone']?.toString(),
                    contactUid: contact['uid']?.toString(),
                    isRegistered: (contact['isRegistered'] as bool?) ?? false,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}