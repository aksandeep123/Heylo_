class ScheduledMessage {
  final String id;
  final String text;
  final String contactName;
  final DateTime scheduledTime;
  final bool isSent;

  ScheduledMessage({
    required this.id,
    required this.text,
    required this.contactName,
    required this.scheduledTime,
    this.isSent = false,
  });
}

List<ScheduledMessage> scheduledMessages = [];