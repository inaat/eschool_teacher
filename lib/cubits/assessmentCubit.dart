import 'package:eschool_teacher/data/models/assessment.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AssessmentState {}

class AssessmentInitial extends AssessmentState {}

class AssessmentFetchInProgress
    extends AssessmentState {}

class AssessmentFetchSuccess extends AssessmentState {
  final List<Assessment> assessments;

  AssessmentFetchSuccess({required this.assessments});
}

class AssessmentFetchFailure extends AssessmentState {
  final String errorMessage;

  AssessmentFetchFailure(this.errorMessage);
}

class AssessmentCubit extends Cubit<AssessmentState> {
  final StudentRepository _studentRepository;

  AssessmentCubit(this._studentRepository)
      : super(AssessmentInitial());

  void updateState(AssessmentState updatedState) {
    emit(updatedState);
  }

  void fetchAssessments({required int studentId}) async {
    emit(AssessmentFetchInProgress());
    try {
      emit(
        AssessmentFetchSuccess(
          assessments: (await _studentRepository.getAssessment(
              studentId: studentId)),
        ),
      );
    } catch (e) {
      emit(AssessmentFetchFailure(e.toString()));
    }
  }

  List<Object> getAssessments() {
    return (state is AssessmentFetchSuccess)
        ? (state as AssessmentFetchSuccess).assessments
        : [];
  }
}
