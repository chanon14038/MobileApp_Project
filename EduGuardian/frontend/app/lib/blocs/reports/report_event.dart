import '../../models/reports.dart';

abstract class ReportEvent {}

class FetchReports extends ReportEvent {
  final String studentId;

  FetchReports(this.studentId);
}

class SubmitReport extends ReportEvent {
  final Reports report;

  SubmitReport(this.report);
}