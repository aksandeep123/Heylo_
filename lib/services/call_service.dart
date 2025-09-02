import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class CallService {
  static Future<void> makeVoiceCall(String phoneNumber, BuildContext context) async {
    try {
      // Request phone permission
      final status = await Permission.phone.request();
      
      if (status.isGranted) {
        final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          _showError(context, 'Cannot make phone calls on this device');
        }
      } else {
        _showError(context, 'Phone permission denied');
      }
    } catch (e) {
      _showError(context, 'Failed to make call: $e');
    }
  }

  static Future<void> makeVideoCall(String phoneNumber, BuildContext context) async {
    try {
      // For video calls, we can use WhatsApp or other video calling apps
      final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
      
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to regular call
        await makeVoiceCall(phoneNumber, context);
      }
    } catch (e) {
      _showError(context, 'Failed to make video call: $e');
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}