class User {
  final String uid;
  final String name;
  final String phoneNumber;
  final String profilePic;
  final bool isOnline;
  final DateTime lastSeen;

  User({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.profilePic,
    required this.isOnline,
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen']),
    );
  }
}