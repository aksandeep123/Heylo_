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
}

List<Status> userStatuses = [];