import 'package:heylo/models/message.dart';

class ChatSummaryService {
  static Map<String, dynamic> generateGroupSummary(List<Message> messages) {
    if (messages.isEmpty) {
      return {
        'totalMessages': 0,
        'summary': 'No messages in this group yet.',
        'mostActiveTime': 'N/A',
        'messageStats': {},
        'keyTopics': [],
      };
    }

    final totalMessages = messages.length;
    final myMessages = messages.where((m) => m.isMe).length;
    final otherMessages = totalMessages - myMessages;

    // Analyze message times
    final hourCounts = <int, int>{};
    for (final message in messages) {
      final hour = int.tryParse(message.time.split(':')[0]) ?? 0;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    final mostActiveHour = hourCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Find key topics (most common words)
    final wordCounts = <String, int>{};
    for (final message in messages) {
      final words = message.text.toLowerCase().split(' ');
      for (final word in words) {
        if (word.length > 3 && !_isCommonWord(word)) {
          wordCounts[word] = (wordCounts[word] ?? 0) + 1;
        }
      }
    }

    final keyTopics = wordCounts.entries
        .where((e) => e.value > 1)
        .map((e) => e.key)
        .take(5)
        .toList();

    // Generate summary text
    String summary = 'This group has $totalMessages messages. ';
    if (myMessages > otherMessages) {
      summary += 'You are the most active member. ';
    } else {
      summary += 'Other members are more active. ';
    }
    
    if (keyTopics.isNotEmpty) {
      summary += 'Main topics discussed: ${keyTopics.join(', ')}.';
    }

    return {
      'totalMessages': totalMessages,
      'summary': summary,
      'mostActiveTime': '${mostActiveHour.toString().padLeft(2, '0')}:00',
      'messageStats': {
        'yourMessages': myMessages,
        'otherMessages': otherMessages,
      },
      'keyTopics': keyTopics,
    };
  }

  static bool _isCommonWord(String word) {
    const commonWords = [
      'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'had',
      'her', 'was', 'one', 'our', 'out', 'day', 'get', 'has', 'him', 'his',
      'how', 'its', 'may', 'new', 'now', 'old', 'see', 'two', 'who', 'boy',
      'did', 'she', 'use', 'her', 'way', 'many', 'oil', 'sit', 'set', 'say',
      'this', 'that', 'with', 'have', 'from', 'they', 'know', 'want', 'been',
      'good', 'much', 'some', 'time', 'very', 'when', 'come', 'here', 'just',
      'like', 'long', 'make', 'many', 'over', 'such', 'take', 'than', 'them',
      'well', 'were', 'what', 'your'
    ];
    return commonWords.contains(word.toLowerCase());
  }
}