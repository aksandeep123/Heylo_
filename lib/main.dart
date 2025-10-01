import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/screens/password_screen.dart';
import 'package:heylo/screens/mobile_layout_screen.dart';
import 'package:heylo/services/message_scheduler.dart';
import 'package:heylo/services/storage_service.dart';
import 'package:heylo/services/simple_notification_service.dart';
import 'package:heylo/services/real_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleNotificationService.initialize();
  await StorageService.loadAll();
  await RealUserService.initialize();
  MessageScheduler.startScheduler();

  // Load theme color index from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final themeColorIndex = prefs.getInt('themeColorIndex') ?? 0;
  runApp(MyApp(themeColorIndex: themeColorIndex));
}

class MyApp extends StatefulWidget {
  final int themeColorIndex;
  const MyApp({Key? key, required this.themeColorIndex}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int themeColorIndex;

  final List<Color> themeColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    themeColorIndex = widget.themeColorIndex;
  }

  void updateTheme(int index) async {
    setState(() {
      themeColorIndex = index;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColorIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heylo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: themeColors[themeColorIndex],
        ),
        scaffoldBackgroundColor: themeColors[themeColorIndex],
        cardColor: themeColors[themeColorIndex],
        canvasColor: themeColors[themeColorIndex],
        dialogBackgroundColor: themeColors[themeColorIndex],
        tabBarTheme: TabBarThemeData(
          indicatorColor: themeColors[themeColorIndex],
          labelColor: themeColors[themeColorIndex],
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
        ),
        // Add other theme properties as needed
      ),
      home: PasswordScreen(
        navigateTo: MobileLayoutScreen(
          updateTheme: updateTheme,
        ),
      ),
    );
  }
}