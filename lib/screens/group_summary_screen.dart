import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/models/group.dart';
import 'package:heylo/models/message.dart';
import 'package:heylo/services/chat_summary_service.dart';
import 'package:fl_chart/fl_chart.dart';

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
      body: _GroupSummaryScrollView(group: group, summary: summary),
    );
  }
}

class _GroupSummaryScrollView extends StatefulWidget {
  final Group group;
  final Map<String, dynamic> summary;

  const _GroupSummaryScrollView({
    Key? key,
    required this.group,
    required this.summary,
  }) : super(key: key);

  @override
  State<_GroupSummaryScrollView> createState() => _GroupSummaryScrollViewState();
}

class _GroupSummaryScrollViewState extends State<_GroupSummaryScrollView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final summary = widget.summary;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      child: SingleChildScrollView(
        controller: _scrollController,
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
                    Text('Total Messages: ${summary['totalMessages']}'),
                    const SizedBox(height: 4),
                    Text('Active Members: ${summary['activeMembersCount']}'),
                    const SizedBox(height: 4),
                    Text('Most Active Member: ${summary['mostActiveMember']}'),
                    const SizedBox(height: 4),
                    Text(summary['summary'].contains('You are the most active member')
                        ? 'You are the most active member.'
                        : 'Other members are more active.'),
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

            // Message Distribution Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bar_chart, color: tabColor),
                        SizedBox(width: 8),
                        Text('Message Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: summary['totalMessages'].toDouble(),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text('You');
                                    case 1:
                                      return const Text('Others');
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: summary['messageStats']['yourMessages'].toDouble(),
                                  color: tabColor,
                                  width: 30,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: summary['messageStats']['otherMessages'].toDouble(),
                                  color: tabColor.withOpacity(0.7),
                                  width: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Message Distribution Pie Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.pie_chart, color: tabColor),
                        SizedBox(width: 8),
                        Text('Message Distribution Pie Chart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieChartSections(summary),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
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

  List<PieChartSectionData> _buildPieChartSections(Map<String, dynamic> summary) {
    final yourMessages = summary['messageStats']['yourMessages'].toDouble();
    final otherMessages = summary['messageStats']['otherMessages'].toDouble();
    final total = yourMessages + otherMessages;

    if (total == 0) {
      return [];
    }

    return [
      PieChartSectionData(
        color: tabColor,
        value: yourMessages,
        title: 'You\n${((yourMessages / total) * 100).toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: tabColor.withOpacity(0.7),
        value: otherMessages,
        title: 'Others\n${((otherMessages / total) * 100).toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
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
