class UserModel {
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? subject;
  final String? phoneNumber;
  final String? email;
  final String? advisorRoom;
  final int? id;
  final int? advisorRoomId;
  final DateTime? lastLoginDate;
  final DateTime? registerDate;

  UserModel({
    this.username,
    this.firstName,
    this.lastName,
    this.subject,
    this.phoneNumber,
    this.email,
    this.advisorRoom,
    this.id,
    this.advisorRoomId,
    this.lastLoginDate,
    this.registerDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      subject: json['subject'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      advisorRoom: json['advisor_room'],
      id: json['id'],
      advisorRoomId: json['advisor_room_id'],
      lastLoginDate: json['last_login_date'] != null
          ? DateTime.parse(json['last_login_date'])
          : null,
      registerDate: json['register_date'] != null
          ? DateTime.parse(json['register_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'subject': subject,
      'phone_number': phoneNumber,
      'email': email,
      'advisor_room': advisorRoom,
      'id': id,
      'advisor_room_id': advisorRoomId,
      'last_login_date': lastLoginDate?.toIso8601String(),
      'register_date': registerDate?.toIso8601String(),
    };
  }
}
