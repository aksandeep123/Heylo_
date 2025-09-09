import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/models/scheduled_message.dart';
import 'package:heylo/services/storage_service.dart';

class ScheduleMessageScreen extends StatefulWidget {
  final String contactName;
  
  const ScheduleMessageScreen({Key? key, required this.contactName}) : super(key: key);

  @override
  State<ScheduleMessageScreen> createState() => _ScheduleMessageScreenState();
}

class _ScheduleMessageScreenState extends State<ScheduleMessageScreen> {
  final TextEditingController messageController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void scheduleMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      final scheduledDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      if (scheduledDateTime.isAfter(DateTime.now())) {
        final scheduledMessage = ScheduledMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: messageController.text.trim(),
          contactName: widget.contactName,
          scheduledTime: scheduledDateTime,
        );

        scheduledMessages.add(scheduledMessage);
        await StorageService.saveScheduledMessages();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message scheduled for ${scheduledDateTime.day}/${scheduledDateTime.month} at ${selectedTime.format(context)}'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a future date and time')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Message'),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: scheduleMessage,
            icon: const Icon(Icons.schedule_send),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To: ${widget.contactName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Schedule for:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, color: tabColor),
                      title: const Text('Date'),
                      subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      onTap: selectDate,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.access_time, color: tabColor),
                      title: const Text('Time'),
                      subtitle: Text(selectedTime.format(context)),
                      onTap: selectTime,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: scheduleMessage,
                icon: const Icon(Icons.schedule_send),
                label: const Text('Schedule Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tabColor,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}