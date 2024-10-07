abstract class UserEvent {}

class FetchUserData extends UserEvent {}

//evenfor update profile
class UpdateProfile extends UserEvent {
  final String firstName;
  final String lastName;
  final String subject;
  final String phoneNumber;
  final String email;
  final String advisorRoom;

  UpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.subject,       // เพิ่ม subject
    required this.phoneNumber,
    required this.email,
    required this.advisorRoom,    // เพิ่ม advisorRoom
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.subject == subject &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.advisorRoom == advisorRoom;
  }

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      subject.hashCode ^
      phoneNumber.hashCode ^
      email.hashCode ^
      advisorRoom.hashCode;
}
