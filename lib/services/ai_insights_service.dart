import 'dart:math';
import 'package:heylo/models/message.dart';

class AIInsightsService {
  static const List<String> positiveWords = [
    'great', 'awesome', 'amazing', 'wonderful', 'fantastic', 'excellent',
    'good', 'nice', 'love', 'like', 'happy', 'excited', 'thank', 'thanks',
    'perfect', 'brilliant', 'super', 'cool', 'fun', 'enjoy'
  ];

  static const List<String> negativeWords = [
    'bad', 'terrible', 'awful', 'horrible', 'hate', 'dislike', 'sad',
    'angry', 'frustrated', 'annoyed', 'worried', 'stressed', 'sorry',
    'disappointed', 'upset', 'tired', 'exhausted'
  ];

  static const List<String> questionWords = [
    'what', 'when', 'where', 'why', 'how', 'who', 'which', 'whose',
    'whom', 'do', 'does', 'did', 'is', 'are', 'was', 'were', 'can',
    'could', 'will', 'would', 'shall', 'should', 'may', 'might'
  ];

  static Map<String, dynamic> analyzeCommunicationStyle(String contactName) {
    List<Message> messages = chatMessages[contactName] ?? [];
    if (messages.isEmpty) {
      return {
        'communicationStyle': 'Unknown',
        'formalityLevel': 0.0,
        'engagementLevel': 0.0,
        'responsePatterns': 'No data available'
      };
    }

    // Analyze formality (use of proper grammar, punctuation)
    double formalityScore = _calculateFormalityScore(messages);

    // Analyze engagement (questions asked, responses given)
    double engagementScore = _calculateEngagementScore(messages);

    // Determine communication style
    String style = _determineCommunicationStyle(formalityScore, engagementScore);

    // Analyze response patterns
    String responsePatterns = _analyzeResponsePatterns(messages);

    return {
      'communicationStyle': style,
      'formalityLevel': formalityScore,
      'engagementLevel': engagementScore,
      'responsePatterns': responsePatterns,
      'totalMessages': messages.length,
      'averageMessageLength': _calculateAverageMessageLength(messages)
    };
  }

  static Map<String, dynamic> analyzeRelationshipDynamics(String contactName) {
    List<Message> messages = chatMessages[contactName] ?? [];
    if (messages.isEmpty) {
      return {'relationshipType': 'Unknown', 'interactionFrequency': 0.0};
    }

    // Calculate interaction frequency (messages per day)
    double frequency = _calculateInteractionFrequency(messages);

    // Analyze emotional tone
    Map<String, double> emotionalTone = _analyzeEmotionalTone(messages);

    // Determine relationship type based on patterns
    String relationshipType = _determineRelationshipType(frequency, emotionalTone);

    return {
      'relationshipType': relationshipType,
      'interactionFrequency': frequency,
      'emotionalTone': emotionalTone,
      'conversationTopics': _extractTopics(messages)
    };
  }

  static List<String> getPersonalizedRecommendations(String contactName) {
    List<String> recommendations = [];

    var styleAnalysis = analyzeCommunicationStyle(contactName);
    var dynamicsAnalysis = analyzeRelationshipDynamics(contactName);

    // Style-based recommendations
    if ((styleAnalysis['formalityLevel'] as double) > 0.7) {
      recommendations.add('Consider being more casual to build closer rapport');
    } else if ((styleAnalysis['formalityLevel'] as double) < 0.3) {
      recommendations.add('Try using more complete sentences for clarity');
    }

    // Engagement recommendations
    if ((styleAnalysis['engagementLevel'] as double) < 0.4) {
      recommendations.add('Ask more questions to increase engagement');
    }

    // Frequency recommendations
    if ((dynamicsAnalysis['interactionFrequency'] as double) < 0.5) {
      recommendations.add('Consider reaching out more frequently to maintain connection');
    }

    // Emotional tone recommendations
    var tone = dynamicsAnalysis['emotionalTone'] as Map<String, double>;
    if ((tone['negative'] ?? 0) > (tone['positive'] ?? 0)) {
      recommendations.add('Focus on positive topics to improve conversation mood');
    }

    return recommendations.isEmpty ? ['Keep up the great communication!'] : recommendations;
  }

  static double _calculateFormalityScore(List<Message> messages) {
    int totalMessages = messages.length;
    if (totalMessages == 0) return 0.0;

    int formalIndicators = 0;

    for (var message in messages) {
      String text = message.text.toLowerCase();

      // Check for proper punctuation
      if (text.contains('.') || text.contains('!') || text.contains('?')) {
        formalIndicators++;
      }

      // Check for capitalization at start
      if (text.isNotEmpty && text[0] == text[0].toUpperCase()) {
        formalIndicators++;
      }

      // Check for polite phrases
      if (text.contains('please') || text.contains('thank you') ||
          text.contains('excuse me') || text.contains('sorry')) {
        formalIndicators++;
      }
    }

    return formalIndicators / (totalMessages * 3); // Max 3 indicators per message
  }

  static double _calculateEngagementScore(List<Message> messages) {
    int totalMessages = messages.length;
    if (totalMessages == 0) return 0.0;

    int questionsAsked = 0;
    int responsesGiven = 0;

    for (var message in messages) {
      String text = message.text.toLowerCase();

      // Count questions
      for (var questionWord in questionWords) {
        if (text.contains(questionWord)) {
          questionsAsked++;
          break;
        }
      }

      // Count responses (messages that aren't just acknowledgments)
      if (text.length > 5 && !text.contains('ok') && !text.contains('yes') &&
          !text.contains('no') && !text.contains('k')) {
        responsesGiven++;
      }
    }

    return (questionsAsked + responsesGiven) / (totalMessages * 2);
  }

  static String _determineCommunicationStyle(double formality, double engagement) {
    if (formality > 0.6 && engagement > 0.6) return 'Professional and Engaging';
    if (formality > 0.6 && engagement <= 0.6) return 'Formal and Reserved';
    if (formality <= 0.6 && engagement > 0.6) return 'Casual and Interactive';
    return 'Casual and Direct';
  }

  static String _analyzeResponsePatterns(List<Message> messages) {
    if (messages.length < 2) return 'Insufficient data';

    List<int> responseTimes = [];
    DateTime? lastMessageTime;

    for (var message in messages) {
      // Simple time parsing (assuming HH:MM format)
      try {
        var timeParts = message.time.split(':');
        int hours = int.parse(timeParts[0]);
        int minutes = int.parse(timeParts[1]);
        var messageTime = DateTime(2023, 1, 1, hours, minutes);

        if (lastMessageTime != null) {
          responseTimes.add(messageTime.difference(lastMessageTime).inMinutes);
        }
        lastMessageTime = messageTime;
      } catch (e) {
        // Skip invalid time formats
      }
    }

    if (responseTimes.isEmpty) return 'Variable response times';

    double avgResponseTime = responseTimes.reduce((a, b) => a + b) / responseTimes.length;

    if (avgResponseTime < 30) return 'Quick responses';
    if (avgResponseTime < 120) return 'Moderate response times';
    return 'Slow responses';
  }

  static double _calculateAverageMessageLength(List<Message> messages) {
    if (messages.isEmpty) return 0.0;
    int totalLength = messages.fold(0, (sum, msg) => sum + msg.text.length);
    return totalLength / messages.length;
  }

  static double _calculateInteractionFrequency(List<Message> messages) {
    if (messages.length < 2) return 0.0;

    // Simple frequency calculation based on message count
    // In a real app, this would use actual timestamps
    return min(messages.length / 30.0, 1.0); // Max frequency of 1.0
  }

  static Map<String, double> _analyzeEmotionalTone(List<Message> messages) {
    int positive = 0;
    int negative = 0;
    int neutral = 0;

    for (var message in messages) {
      String text = message.text.toLowerCase();
      bool hasPositive = positiveWords.any((word) => text.contains(word));
      bool hasNegative = negativeWords.any((word) => text.contains(word));

      if (hasPositive && !hasNegative) positive++;
      else if (hasNegative && !hasPositive) negative++;
      else neutral++;
    }

    int total = messages.length;
    if (total == 0) return {'positive': 0.0, 'negative': 0.0, 'neutral': 0.0};

    return {
      'positive': positive / total,
      'negative': negative / total,
      'neutral': neutral / total
    };
  }

  static String _determineRelationshipType(double frequency, Map<String, double> tone) {
    double positiveTone = tone['positive'] ?? 0.0;
    double negativeTone = tone['negative'] ?? 0.0;

    if (frequency > 0.7 && positiveTone > 0.6) return 'Close Friend';
    if (frequency > 0.5 && positiveTone > 0.4) return 'Good Friend';
    if (frequency > 0.3) return 'Acquaintance';
    if (negativeTone > 0.3) return 'Distant Contact';
    return 'Occasional Contact';
  }

  static List<String> _extractTopics(List<Message> messages) {
    // Simple topic extraction based on keywords
    Map<String, int> topicCounts = {};
    List<String> topics = [];

    for (var message in messages) {
      String text = message.text.toLowerCase();

      // Define topic keywords
      Map<String, List<String>> topicKeywords = {
        'Work': ['work', 'job', 'meeting', 'project', 'office', 'business'],
        'Food': ['food', 'eat', 'drink', 'restaurant', 'recipe', 'cook'],
        'Travel': ['travel', 'trip', 'vacation', 'flight', 'hotel'],
        'Sports': ['game', 'sport', 'football', 'basketball', 'tennis'],
        'Movies': ['movie', 'film', 'watch', 'cinema', 'actor'],
        'Music': ['music', 'song', 'band', 'concert', 'listen'],
        'Weather': ['weather', 'rain', 'sunny', 'cold', 'hot'],
        'Health': ['health', 'doctor', 'sick', 'exercise', 'gym']
      };

      for (var topic in topicKeywords.keys) {
        for (var keyword in topicKeywords[topic]!) {
          if (text.contains(keyword)) {
            topicCounts[topic] = (topicCounts[topic] ?? 0) + 1;
            break;
          }
        }
      }
    }

    // Get top 3 topics
    var sortedTopics = topicCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTopics.take(3).map((e) => e.key).toList();
  }
}
