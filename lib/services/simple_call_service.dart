import 'package:flutter/material.dart';

class CallService {
  static void makeVoiceCall(String phoneNumber, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice call to $phoneNumber - Feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  static void makeVideoCall(String phoneNumber, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Video call to $phoneNumber - Feature coming soon!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}