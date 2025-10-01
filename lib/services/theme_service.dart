import 'package:flutter/material.dart';
import 'package:heylo/services/mood_analysis_service.dart';

class ThemeService {
  static final Map<String, Map<String, dynamic>> chatThemes = {
    'neutral': {
      'backgroundColor': Color(0xFF1F1F1F),
      'messageBubbleColor': Color(0xFF2D2D2D),
      'textColor': Colors.white,
      'accentColor': Color(0xFF007AFF),
      'emoji': '😐',
      'description': 'Standard theme'
    },
    'cheerful': {
      'backgroundColor': Color(0xFFFFF8E1), // Light yellow background
      'messageBubbleColor': Color(0xFFFFF3C4), // Lighter yellow bubbles
      'textColor': Color(0xFF2D3748), // Dark text for contrast
      'accentColor': Color(0xFFFFD700), // Gold accent
      'emoji': '😊',
      'description': 'Bright and cheerful theme'
    },
    'serene': {
      'backgroundColor': Color(0xFFE6F3FF), // Light blue background
      'messageBubbleColor': Color(0xFFB3D9FF), // Soft blue bubbles
      'textColor': Color(0xFF2D3748), // Dark text
      'accentColor': Color(0xFF4A90E2), // Calm blue accent
      'emoji': '😌',
      'description': 'Calm and peaceful theme'
    },
    'comforting': {
      'backgroundColor': Color(0xFFF0F8FF), // Alice blue background
      'messageBubbleColor': Color(0xFFE6E6FA), // Lavender bubbles
      'textColor': Color(0xFF2D3748), // Dark text
      'accentColor': Color(0xFF9370DB), // Medium purple accent
      'emoji': '🤗',
      'description': 'Warm and comforting theme'
    },
    'calming': {
      'backgroundColor': Color(0xFFE8F5E8), // Light green background
      'messageBubbleColor': Color(0xFFC8E6C9), // Soft green bubbles
      'textColor': Color(0xFF2D3748), // Dark text
      'accentColor': Color(0xFF66BB6A), // Calming green accent
      'emoji': '🧘',
      'description': 'Soothing and calming theme'
    },
    'excited': {
      'backgroundColor': Color(0xFFFFF3E0), // Light orange background
      'messageBubbleColor': Color(0xFFFFE0B2), // Peach bubbles
      'textColor': Color(0xFF2D3748), // Dark text
      'accentColor': Color(0xFFFF9800), // Orange accent
      'emoji': '🤩',
      'description': 'Energetic and exciting theme'
    },
    'romantic': {
      'backgroundColor': Color(0xFFFFF0F5), // Lavender blush background
      'messageBubbleColor': Color(0xFFFFDAB9), // Peach puff bubbles
      'textColor': Color(0xFF2D3748), // Dark text
      'accentColor': Color(0xFFE91E63), // Pink accent
      'emoji': '💕',
      'description': 'Romantic and loving theme'
    },
    'professional': {
      'backgroundColor': Color(0xFFF8F9FA), // Light gray background
      'messageBubbleColor': Color(0xFFE9ECEF), // Light gray bubbles
      'textColor': Color(0xFF212529), // Dark text
      'accentColor': Color(0xFF495057), // Dark gray accent
      'emoji': '💼',
      'description': 'Clean and professional theme'
    }
  };

  static Map<String, dynamic> getCurrentTheme(String contactName) {
    String moodTheme = MoodAnalysisService.getMoodTheme(contactName);
    return chatThemes[moodTheme] ?? chatThemes['neutral']!;
  }

  static Map<String, dynamic> getThemeByName(String themeName) {
    return chatThemes[themeName] ?? chatThemes['neutral']!;
  }

  static List<String> getAvailableThemes() {
    return chatThemes.keys.toList();
  }

  static String getThemeEmoji(String themeName) {
    return chatThemes[themeName]?['emoji'] ?? '😐';
  }

  static String getThemeDescription(String themeName) {
    return chatThemes[themeName]?['description'] ?? 'Standard theme';
  }

  static Color getBackgroundColor(String themeName) {
    return chatThemes[themeName]?['backgroundColor'] ?? const Color(0xFF1F1F1F);
  }

  static Color getMessageBubbleColor(String themeName) {
    return chatThemes[themeName]?['messageBubbleColor'] ?? const Color(0xFF2D2D2D);
  }

  static Color getTextColor(String themeName) {
    return chatThemes[themeName]?['textColor'] ?? Colors.white;
  }

  static Color getAccentColor(String themeName) {
    return chatThemes[themeName]?['accentColor'] ?? const Color(0xFF007AFF);
  }

  static ThemeData createThemeData(String themeName) {
    Map<String, dynamic> theme = getThemeByName(themeName);

    return ThemeData(
      scaffoldBackgroundColor: theme['backgroundColor'],
      primaryColor: theme['accentColor'],
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: theme['textColor']),
        bodyMedium: TextStyle(color: theme['textColor']),
        bodySmall: TextStyle(color: theme['textColor']),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: theme['accentColor'],
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: theme['accentColor'],
      ),
    );
  }

  static BoxDecoration getMessageBubbleDecoration(String themeName, bool isMe) {
    Map<String, dynamic> theme = getThemeByName(themeName);

    return BoxDecoration(
      color: isMe ? theme['accentColor'] : theme['messageBubbleColor'],
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(
        color: isMe ? Colors.transparent : theme['accentColor'].withOpacity(0.3),
        width: 1.0,
      ),
    );
  }

  static TextStyle getMessageTextStyle(String themeName, bool isMe) {
    Map<String, dynamic> theme = getThemeByName(themeName);

    return TextStyle(
      color: isMe ? Colors.white : theme['textColor'],
      fontSize: 16.0,
    );
  }

  static TextStyle getTimeTextStyle(String themeName) {
    Map<String, dynamic> theme = getThemeByName(themeName);

    return TextStyle(
      color: theme['textColor'].withOpacity(0.6),
      fontSize: 12.0,
    );
  }
}
