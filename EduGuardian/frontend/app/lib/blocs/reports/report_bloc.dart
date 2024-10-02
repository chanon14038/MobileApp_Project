import 'package:app/blocs/reports/report_state.dart';
import 'package:app/blocs/reports/report_event.dart';
import 'package:app/repositories/report_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;

  ReportBloc(this.reportRepository) : super(ReportInitial()) {
    on<FetchReports>((event, emit) async {
      emit(ReportLoading());
      try {
        final reports = await reportRepository.getReports(event.studentId);
        emit(ReportLoaded(reports));
      } catch (e) {
        emit(ReportError(e.toString()));
      }
    });
  }
}
