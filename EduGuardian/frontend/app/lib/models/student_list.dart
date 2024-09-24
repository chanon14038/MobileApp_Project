class Student {
  String? classroom;
  String? firstName;
  String? advisor;
  String? classroomId;
  String? studentId;
  String? lastName;
  String? advisorId;

 


  Student({
    this.classroom,
    this.firstName,
    this.advisor,
    this.classroomId,
    this.studentId,
    this.lastName,
    this.advisorId,
  });

  // สร้าง factory constructor เพื่อแปลงจาก JSON เป็น Object
  factory Student.fromJson(Map<String, dynamic> json) => Student(
        classroom: json['classroom'],
        firstName: json['first_name'],
        advisor: json['advisor'],
        classroomId: json['classroom_id'],
        studentId: json['student_id'],
        lastName: json['last_name'],
        advisorId: json['advisor_id'],
      );
  // แปลง Object กลับเป็น JSON (กรณีที่ต้องการส่งข้อมูลกลับไป)
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
