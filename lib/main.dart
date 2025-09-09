import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/screens/password_screen.dart';
import 'package:heylo/services/message_scheduler.dart';
import 'package:heylo/services/storage_service.dart';
import 'package:heylo/services/simple_notification_service.dart';
import 'package:heylo/services/real_user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleNotificationService.initialize();
  await StorageService.loadAll();
  await RealUserService.initialize();
  MessageScheduler.startScheduler();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heylo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const PasswordScreen(),
    );
  }
}