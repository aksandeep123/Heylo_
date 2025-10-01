import 'package:flutter/material.dart';
import 'package:heylo/services/ai_insights_service.dart';
import 'package:heylo/colors.dart';

class AIInsightsScreen extends StatefulWidget {
  final String contactName;

  const AIInsightsScreen({Key? key, required this.contactName}) : super(key: key);

  @override
  State<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends State<AIInsightsScreen> {
  late Map<String, dynamic> communicationStyle;
  late Map<String, dynamic> relationshipDynamics;
  late List<String> recommendations;

  @override
  void initState() {
    super.initState();
    communicationStyle = AIInsightsService.analyzeCommunicationStyle(widget.contactName);
    relationshipDynamics = AIInsightsService.analyzeRelationshipDynamics(widget.contactName);
    recommendations = AIInsightsService.getPersonalizedRecommendations(widget.contactName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('AI Insights - ${widget.contactName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Communication Style Analysis'),
            _buildCommunicationStyleCard(),

            const SizedBox(height: 20),
            _buildSectionTitle('Relationship Dynamics'),
            _buildRelationshipDynamicsCard(),

            const SizedBox(height: 20),
            _buildSectionTitle('Conversation Topics'),
            _buildTopicsCard(),

            const SizedBox(height: 20),
            _buildSectionTitle('Personalized Recommendations'),
            _buildRecommendationsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCommunicationStyleCard() {
    return Card(
      color: mobileChatBoxColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Style: ${communicationStyle['communicationStyle']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildProgressBar('Formality Level', communicationStyle['formalityLevel']),
            _buildProgressBar('Engagement Level', communicationStyle['engagementLevel']),
            const SizedBox(height: 10),
            Text(
              'Response Patterns: ${communicationStyle['responsePatterns']}',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'Total Messages: ${communicationStyle['totalMessages']}',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'Average Message Length: ${communicationStyle['averageMessageLength'].toStringAsFixed(1)} characters',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipDynamicsCard() {
    return Card(
      color: mobileChatBoxColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Relationship Type: ${relationshipDynamics['relationshipType']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildProgressBar('Interaction Frequency', relationshipDynamics['interactionFrequency']),
            const SizedBox(height: 10),
            const Text(
              'Emotional Tone:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 5),
            _buildEmotionalToneBars(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicsCard() {
    List<String> topics = relationshipDynamics['conversationTopics'] as List<String>;

    return Card(
      color: mobileChatBoxColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Conversation Topics:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            if (topics.isEmpty)
              const Text(
                'No specific topics detected',
                style: TextStyle(color: Colors.white70),
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: topics.map((topic) => Chip(
                  label: Text(topic),
                  backgroundColor: tabColor,
                  labelStyle: const TextStyle(color: Colors.white),
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Card(
      color: mobileChatBoxColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Recommendations:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            if (recommendations.isEmpty)
              const Text(
                'No specific recommendations at this time',
                style: TextStyle(color: Colors.white70),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.yellow, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rec,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${(value * 100).toStringAsFixed(0)}%',
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[700],
          valueColor: AlwaysStoppedAnimation<Color>(tabColor),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEmotionalToneBars() {
    Map<String, double> tone = relationshipDynamics['emotionalTone'] as Map<String, double>;

    return Column(
      children: [
        _buildToneBar('Positive', tone['positive'] ?? 0, Colors.green),
        _buildToneBar('Negative', tone['negative'] ?? 0, Colors.red),
        _buildToneBar('Neutral', tone['neutral'] ?? 0, Colors.grey),
      ],
    );
  }

  Widget _buildToneBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${(value * 100).toStringAsFixed(0)}%',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
