class Reports {
  String? studentId;
  String? description;
  String? reporterName;

  Reports({
    this.studentId,
    this.description,
    this.reporterName,
  });

  // Factory constructor to create a Reports instance from JSON
  factory Reports.fromJson(Map<String, dynamic> json) => Reports(
        studentId: json['student_id'],
        description: json['description'],
        reporterName: json['reporterName'],
      );

  // Convert Reports instance to JSON
  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'description': description,
      };
}
