abstract class ReportEvent {}

class FetchReports extends ReportEvent {
  final String studentId;

  FetchReports(this.studentId);
}