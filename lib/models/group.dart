class Group {
  final String id;
  final String name;
  final String profilePic;
  final List<String> members;
  final String lastMessage;
  final String time;

  Group({
    required this.id,
    required this.name,
    required this.profilePic,
    required this.members,
    required this.lastMessage,
    required this.time,
  });
}

List<Group> groups = [];