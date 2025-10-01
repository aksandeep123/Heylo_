import 'dart:math';
import 'package:heylo/models/message.dart';

class MoodAnalysisService {
  static const List<String> positiveEmojis = [
    '😊', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😇', '🙂', '🙃',
    '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚', '😋', '😛', '😝',
    '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🤩', '🥳', '😏', '😒', '😞',
    '😔', '😟', '😕', '🙁', '☹️', '😣', '😖', '😫', '😩', '🥺', '😢',
    '😭', '😤', '😠', '😡', '🤬', '🤯', '😳', '🥵', '🥶', '😱', '😨',
    '😰', '😥', '😓', '🤗', '🤔', '🤭', '🤫', '🤥', '😶', '😐', '😑',
    '😬', '🙄', '😯', '😦', '😧', '😮', '😲', '🥱', '😴', '🤤', '😪',
    '😵', '🤐', '🥴', '🤢', '🤮', '🤧', '😷', '🤒', '🤕', '🤑', '🤠',
    '😈', '👿', '👹', '👺', '🤡', '💩', '👻', '💀', '☠️', '👽', '👾',
    '🤖', '🎃', '😺', '😸', '😹', '😻', '😼', '😽', '🙀', '😿', '😾'
  ];

  static const List<String> negativeEmojis = [
    '😢', '😭', '😤', '😠', '😡', '🤬', '😞', '😔', '😟', '😕', '🙁',
    '☹️', '😣', '😖', '😫', '😩', '🥺', '😰', '😥', '😓', '😨', '😱',
    '😵', '🤮', '🤢', '🤧', '😷', '🤒', '🤕', '💀', '☠️', '👻', '👹',
    '👺', '😾', '😿', '🙀'
  ];

  static const List<String> excitedEmojis = [
    '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '🥳', '🤩', '😎', '😏'
  ];

  static const List<String> calmEmojis = [
    '😌', '😊', '🙂', '😇', '🤗', '😴', '😪', '😶', '😐'
  ];

  static const List<String> stressedEmojis = [
    '😰', '😥', '😓', '😨', '😱', '😵', '😤', '😠', '😡', '🤬'
  ];

  static const Map<String, List<String>> moodKeywords = {
    'happy': ['happy', 'joy', 'excited', 'great', 'awesome', 'amazing', 'wonderful', 'fantastic', 'excellent', 'good', 'nice', 'love', 'like', 'enjoy', 'fun', 'perfect', 'brilliant', 'super', 'cool'],
    'sad': ['sad', 'unhappy', 'depressed', 'down', 'blue', 'sorry', 'disappointed', 'upset', 'tired', 'exhausted', 'worried', 'stressed', 'angry', 'frustrated', 'annoyed'],
    'excited': ['excited', 'thrilled', 'pumped', 'hyped', 'amazed', 'wow', 'omg', 'incredible', 'unbelievable', 'mind-blowing'],
    'calm': ['calm', 'relaxed', 'peaceful', 'serene', 'chill', 'okay', 'fine', 'alright'],
    'stressed': ['stressed', 'overwhelmed', 'anxious', 'worried', 'nervous', 'panicked', 'freaking out', 'losing it'],
    'angry': ['angry', 'mad', 'furious', 'pissed', 'annoyed', 'irritated', 'frustrated', 'hate', 'dislike']
  };

  static Map<String, double> analyzeCurrentMood(String contactName) {
    List<Message> messages = chatMessages[contactName] ?? [];
    if (messages.isEmpty) {
      return {'neutral': 1.0, 'happy': 0.0, 'sad': 0.0, 'excited': 0.0, 'calm': 0.0, 'stressed': 0.0, 'angry': 0.0};
    }

    // Get recent messages (last 10 messages or last hour, whichever is smaller)
    List<Message> recentMessages = _getRecentMessages(messages);

    Map<String, double> moodScores = {
      'neutral': 0.0,
      'happy': 0.0,
      'sad': 0.0,
      'excited': 0.0,
      'calm': 0.0,
      'stressed': 0.0,
      'angry': 0.0
    };

    for (var message in recentMessages) {
      String text = message.text.toLowerCase();
      Map<String, double> messageMood = _analyzeMessageMood(text);
      moodScores = _combineMoodScores(moodScores, messageMood);
    }

    // Normalize scores
    double total = moodScores.values.reduce((a, b) => a + b);
    if (total > 0) {
      moodScores.updateAll((key, value) => value / total);
    }

    return moodScores;
  }

  static String getMoodTheme(String contactName) {
    Map<String, double> mood = analyzeCurrentMood(contactName);

    // Find the dominant mood
    String dominantMood = 'neutral';
    double maxScore = 0.0;

    mood.forEach((key, value) {
      if (value > maxScore) {
        maxScore = value;
        dominantMood = key;
      }
    });

    // Return appropriate theme based on mood
    switch (dominantMood) {
      case 'happy':
      case 'excited':
        return 'cheerful';
      case 'calm':
        return 'serene';
      case 'sad':
        return 'comforting';
      case 'stressed':
      case 'angry':
        return 'calming';
      default:
        return 'neutral';
    }
  }

  static Map<String, double> getMoodHistory(String contactName, {int days = 7}) {
    List<Message> messages = chatMessages[contactName] ?? [];
    if (messages.isEmpty) {
      return {};
    }

    Map<String, List<Map<String, double>>> dailyMoods = {};

    // Group messages by day and analyze mood for each day
    for (var message in messages) {
      // Simple date extraction from time string (assuming format includes date)
      String dayKey = message.time.split(' ')[0]; // Assuming format like "2023-12-01 14:30"

      if (!dailyMoods.containsKey(dayKey)) {
        dailyMoods[dayKey] = [];
      }

      Map<String, double> messageMood = _analyzeMessageMood(message.text.toLowerCase());
      dailyMoods[dayKey]!.add(messageMood);
    }

    // Calculate average mood for each day
    Map<String, double> dailyAverageMood = {};
    dailyMoods.forEach((day, moods) {
      Map<String, double> averageMood = {
        'neutral': 0.0,
        'happy': 0.0,
        'sad': 0.0,
        'excited': 0.0,
        'calm': 0.0,
        'stressed': 0.0,
        'angry': 0.0
      };

      for (var mood in moods) {
        averageMood = _combineMoodScores(averageMood, mood);
      }

      // Normalize
      double total = averageMood.values.reduce((a, b) => a + b);
      if (total > 0) {
        averageMood.updateAll((key, value) => value / total);
      }

      // Store the dominant mood score for that day
      String dominantMood = 'neutral';
      double maxScore = 0.0;
      averageMood.forEach((key, value) {
        if (value > maxScore) {
          maxScore = value;
          dominantMood = key;
        }
      });

      dailyAverageMood[day] = _moodToScore(dominantMood);
    });

    return dailyAverageMood;
  }

  static Map<String, double> _analyzeMessageMood(String text) {
    Map<String, double> scores = {
      'neutral': 1.0, // Start with neutral as baseline
      'happy': 0.0,
      'sad': 0.0,
      'excited': 0.0,
      'calm': 0.0,
      'stressed': 0.0,
      'angry': 0.0
    };

    // Analyze emojis
    int positiveEmojiCount = positiveEmojis.where((emoji) => text.contains(emoji)).length;
    int negativeEmojiCount = negativeEmojis.where((emoji) => text.contains(emoji)).length;
    int excitedEmojiCount = excitedEmojis.where((emoji) => text.contains(emoji)).length;
    int calmEmojiCount = calmEmojis.where((emoji) => text.contains(emoji)).length;
    int stressedEmojiCount = stressedEmojis.where((emoji) => text.contains(emoji)).length;

    // Analyze keywords
    moodKeywords.forEach((mood, keywords) {
      int keywordCount = keywords.where((keyword) => text.contains(keyword)).length;
      if (keywordCount > 0) {
        scores[mood] = scores[mood]! + keywordCount.toDouble();
        scores['neutral'] = max(0, scores['neutral']! - keywordCount.toDouble());
      }
    });

    // Boost scores based on emojis
    if (positiveEmojiCount > 0) scores['happy'] = scores['happy']! + positiveEmojiCount.toDouble();
    if (negativeEmojiCount > 0) scores['sad'] = scores['sad']! + negativeEmojiCount.toDouble();
    if (excitedEmojiCount > 0) scores['excited'] = scores['excited']! + excitedEmojiCount.toDouble();
    if (calmEmojiCount > 0) scores['calm'] = scores['calm']! + calmEmojiCount.toDouble();
    if (stressedEmojiCount > 0) scores['stressed'] = scores['stressed']! + stressedEmojiCount.toDouble();

    // Check for exclamation marks (excitement) and question marks (curiosity)
    int exclamationCount = '!'.allMatches(text).length;
    int questionCount = '?'.allMatches(text).length;

    if (exclamationCount > 0) {
      scores['excited'] = scores['excited']! + exclamationCount.toDouble() * 0.5;
    }

    if (questionCount > 0) {
      scores['happy'] = scores['happy']! + questionCount.toDouble() * 0.3; // Questions can indicate engagement
    }

    // Check for all caps (could indicate excitement or anger)
    bool isAllCaps = text == text.toUpperCase() && text.length > 3;
    if (isAllCaps) {
      if (scores['happy']! > scores['sad']!) {
        scores['excited'] = scores['excited']! + 1.0;
      } else {
        scores['angry'] = scores['angry']! + 1.0;
      }
    }

    return scores;
  }

  static Map<String, double> _combineMoodScores(Map<String, double> mood1, Map<String, double> mood2) {
    Map<String, double> combined = {};
    mood1.forEach((key, value) {
      combined[key] = value + mood2[key]!;
    });
    return combined;
  }

  static List<Message> _getRecentMessages(List<Message> messages) {
    if (messages.length <= 10) return messages;

    // For now, just return last 10 messages
    // In a real app, this would filter by time
    return messages.sublist(max(0, messages.length - 10));
  }

  static double _moodToScore(String mood) {
    switch (mood) {
      case 'happy':
      case 'excited':
        return 0.8;
      case 'calm':
        return 0.6;
      case 'neutral':
        return 0.5;
      case 'sad':
        return 0.3;
      case 'stressed':
      case 'angry':
        return 0.2;
      default:
        return 0.5;
    }
  }
}
