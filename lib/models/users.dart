class Users {
  final String userId;
  final String username;
  final String phoneNumber;
  final String userPin;

  Users({
    required this.userId, 
    required this.username, 
    required this.phoneNumber, 
    required this.userPin
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'user_id' : userId,
      'username' : username,
      'phone_number' : phoneNumber,
      'user_pin' : userPin,
    };
  }
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users (
      userId: json['user_id'] as String,
      username: json['username'] as String,
      phoneNumber: json['phone_number'] as String,
      userPin : json['user_pin'] as String,
    );
  }
}