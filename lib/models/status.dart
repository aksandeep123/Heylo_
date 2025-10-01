class Status {
  final String id;
  final String userName;
  final String userImage;
  final String mediaPath;
  final String mediaType; // 'image' or 'video'
  final String? musicPath;
  final DateTime timestamp;
  final List<String> viewedBy;

  Status({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.mediaPath,
    required this.mediaType,
    this.musicPath,
    required this.timestamp,
    this.viewedBy = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'userImage': userImage,
      'mediaPath': mediaPath,
      'mediaType': mediaType,
      'musicPath': musicPath,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'viewedBy': viewedBy,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'],
      userName: map['userName'],
      userImage: map['userImage'],
      mediaPath: map['mediaPath'],
      mediaType: map['mediaType'],
      musicPath: map['musicPath'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      viewedBy: List<String>.from(map['viewedBy'] ?? []),
    );
  }
}

List<Status> userStatuses = [];
