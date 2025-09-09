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

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isMe': isMe,
      'time': time,
      'contactName': contactName,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] ?? '',
      isMe: map['isMe'] ?? false,
      time: map['time'] ?? '',
      contactName: map['contactName'] ?? '',
    );
  }
}

Map<String, List<Message>> chatMessages = {};