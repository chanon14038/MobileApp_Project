class Subject {
  final String? description;
  final String? classroom;
  final String? subject;
  final String? subjectId;
  final int? id;
  final int? teacherId;

  Subject({
    this.description,
    this.classroom,
    this.subject,
    this.subjectId,
    this.id,
    this.teacherId,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      description: json['description'],
      classroom: json['classroom'],
      subject: json['subject'],
      subjectId: json['subject_id'],
      id: json['id'],
      teacherId: json['teacher_id'],
    );
  }
}
