import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/widgets/realtime_contacts_list.dart';
import 'package:heylo/widgets/status_list.dart';
import 'package:heylo/widgets/calls_list.dart';
import 'package:heylo/screens/simple_add_contact_screen.dart';
import 'package:heylo/screens/search_screen.dart';
import 'package:heylo/screens/simple_status_screen.dart';
import 'package:heylo/screens/simple_whatsapp_integration_screen.dart';
import 'package:heylo/screens/create_group_screen.dart';
import 'package:heylo/screens/scheduled_messages_screen.dart';
import 'package:heylo/screens/theme_selection_screen.dart';

class MobileLayoutScreen extends StatefulWidget {
  final Function(int)? updateTheme;
  const MobileLayoutScreen({Key? key, this.updateTheme}) : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen>
    with TickerProviderStateMixin {

  late TabController tabController;
  bool selectionMode = false;

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

  void enableSelectionMode() {
    setState(() {
      selectionMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                      Icon(Icons.schedule_send, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Scheduled Messages'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScheduledMessagesScreen(),
                      ),
                    );
                  },
                ),
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
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.color_lens, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('Change Theme'),
                    ],
                  ),
                  onTap: () async {
                    final selectedIndex = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThemeSelectionScreen(),
                      ),
                    );
                    if (selectedIndex != null && widget.updateTheme != null) {
                      widget.updateTheme!(selectedIndex);
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.select_all, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Select'),
                    ],
                  ),
                  onTap: () {
                    enableSelectionMode();
                  },
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorWeight: 4,
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
          children: [
            RealtimeContactsList(
              selectionMode: selectionMode,
              onSelectionModeChanged: (enabled) {
                setState(() {
                  selectionMode = enabled;
                });
              },
            ),
            const StatusList(),
            const CallsList(),
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
                    backgroundColor: Theme.of(context).indicatorColor,
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
                    backgroundColor: Theme.of(context).indicatorColor,
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
                backgroundColor: Theme.of(context).indicatorColor,
                child: Icon(
                  tabController.index == 1 ? Icons.camera_alt : Icons.add_call,
                  color: Colors.white,
                ),
              ),
      );
    }
}