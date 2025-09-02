class Message {
  final String text;
  final bool isMe;
  final String time;
  final String contactName;

  Message({
    required this.text,
    required this.isMe,
    required this.time,
    required this.contactName,
  });
}

Map<String, List<Message>> chatMessages = {};