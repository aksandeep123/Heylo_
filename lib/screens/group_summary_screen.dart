import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/models/group.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/services/chat_summary_service.dart';

class GroupSummaryScreen extends StatelessWidget {
  final Group group;
  final List<Message> messages;

  const GroupSummaryScreen({
    Key? key,
    required this.group,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary = ChatSummaryService.generateGroupSummary(messages);

    return Scaffold(
      appBar: AppBar(
        title: Text('${group.name} Summary'),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(group.profilePic),
                      radius: 30,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text('${group.members.length} members'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Summary Text
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.summarize, color: tabColor),
                        SizedBox(width: 8),
                        Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(summary['summary']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statistics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics, color: tabColor),
                        SizedBox(width: 8),
                        Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard('Total Messages', summary['totalMessages'].toString()),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard('Most Active Time', summary['mostActiveTime']),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard('Your Messages', summary['messageStats']['yourMessages'].toString()),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard('Others Messages', summary['messageStats']['otherMessages'].toString()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Key Topics
            if (summary['keyTopics'].isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.topic, color: tabColor),
                          SizedBox(width: 8),
                          Text('Key Topics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (summary['keyTopics'] as List<String>)
                            .map((topic) => Chip(
                                  label: Text(topic),
                                  backgroundColor: tabColor.withOpacity(0.2),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tabColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}