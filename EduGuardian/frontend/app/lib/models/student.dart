class Student {
  String? classroom;
  String? firstName;
  String? advisor;
  int? classroomId;
  String? studentId;
  String? lastName;
  int? advisorId;

  Student({
    this.classroom,
    this.advisorId,
    this.firstName,
    this.advisor,
    this.classroomId,
    this.studentId,
    this.lastName,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        classroom: json['classroom'],
        firstName: json['first_name'],
        advisor: json['advisor'],
        classroomId: json['classroom_id'],
        studentId: json['student_id'],
        lastName: json['last_name'],
        advisorId: json['advisor_id'],
      );

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'classroom': classroom,
        'student_id': studentId,
      };
}
