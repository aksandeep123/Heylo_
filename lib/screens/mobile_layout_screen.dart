import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/widgets/contacts_list.dart';
import 'package:heylo/widgets/status_list.dart';
import 'package:heylo/widgets/calls_list.dart';
import 'package:heylo/screens/add_contact_screen.dart';
import 'package:heylo/screens/search_screen.dart';
import 'package:heylo/screens/add_status_screen.dart';
import 'package:heylo/screens/whatsapp_integration_screen.dart';
import 'package:heylo/screens/create_group_screen.dart';

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen>
    with TickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'Heylo',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.integration_instructions, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Heylo Integration'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WhatsAppIntegrationScreen(),
                      ),
                    );
                  },
                ),
                const PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            ContactsList(),
            StatusList(),
            CallsList(),
          ],
        ),
        floatingActionButton: tabController.index == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    mini: true,
                    heroTag: "group",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
                      );
                    },
                    backgroundColor: tabColor,
                    child: const Icon(Icons.group_add),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: "contact",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddContactScreen()),
                      );
                    },
                    backgroundColor: tabColor,
                    child: const Icon(Icons.message),
                  ),
                ],
              )
            : FloatingActionButton(
                onPressed: () {
                  if (tabController.index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddStatusScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('New call coming soon!')),
                    );
                  }
                },
                backgroundColor: tabColor,
                child: Icon(
                  tabController.index == 1 ? Icons.camera_alt : Icons.add_call,
                  color: Colors.white,
                ),
              ),
    );
  }
}
