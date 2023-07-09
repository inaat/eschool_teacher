import 'package:eschool_teacher/data/models/assessment.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubmitAssessmentState {}

class SubmitAssessmentInitial extends SubmitAssessmentState {}

class SubmitAssessmentInProgress extends SubmitAssessmentState {}

class SubmitAssessmentSuccess extends SubmitAssessmentState {}

class SubmitAssessmentFailure extends SubmitAssessmentState {
  final String errorMessage;

  SubmitAssessmentFailure(this.errorMessage);
}

class SubmitAssessmentCubit extends Cubit<SubmitAssessmentState> {
  final TeacherRepository _teacherRepository;

  SubmitAssessmentCubit(this._teacherRepository)
      : super(SubmitAssessmentInitial());

  void submitAssessment(
      {required int studentId, required List<Assessment> assessment}) async {
    emit(SubmitAssessmentInProgress());
     try {
    await _teacherRepository.submitAssessment(
        studentId: studentId,
        assessmentData: assessment
            .map(
              (assessment) => {
                "id": assessment.id,
                 "title": assessment.title,
                 "subTitle": assessment.subTitle,
                 "isAverage": assessment.isAverage,
                 "isGood": assessment.isGood,
                  "isPoor": assessment.isPoor
              },
            )
            .toList());
     emit(SubmitAssessmentSuccess());
    } catch (e) {
    emit(SubmitAssessmentFailure(e.toString()));
    }
  }
}
