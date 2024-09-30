class Student {
  String? classroom;
  String? firstName;
  String? advisor;
  String? classroomId;
  String? studentId;
  String? lastName;
  int? advisorId;

  Student({
    this.classroom,
    this.firstName,
    this.advisor,
    this.classroomId,
    this.studentId,
    this.lastName,
    this.advisorId,
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
        'classroom': classroom,
        'first_name': firstName,
        'advisor': advisor,
        'classroom_id': classroomId,
        'student_id': studentId,
        'last_name': lastName,
        'advisor_id': advisorId,
      };
}
