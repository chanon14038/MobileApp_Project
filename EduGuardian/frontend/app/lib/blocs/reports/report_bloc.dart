import 'package:app/blocs/reports/report_state.dart';
import 'package:app/blocs/reports/report_event.dart';
import 'package:app/repositories/report_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;

  ReportBloc(this.reportRepository) : super(ReportInitial()) {
    // Handle FetchReports event
    on<FetchReports>((event, emit) async {
      emit(ReportLoading());
      try {
        final reports = await reportRepository.getReports(event.studentId);
        emit(ReportLoaded(reports));
      } catch (e) {
        emit(ReportError(e.toString()));
      }
    });

    // Handle SubmitReport event
    on<SubmitReport>((event, emit) async {
      emit(ReportSubmitting());
      try {
        await reportRepository.postReport(event.report);
        emit(ReportSubmitted());
      } catch (e) {
        emit(ReportError(e.toString()));
      }
    });
  }
}